
from airflow.sdk import dag, task
from airflow.operators.bash import BashOperator
import time
from databricks.sdk import WorkspaceClient
from databricks.sdk.service.jobs import RunLifeCycleState, RunResultState
import pendulum
@dag(
        dag_id="orchestrate",
        schedule="0 11 * * *",
        catchup=False,
        start_date = pendulum.datetime(2026, 10, 25, tz="UTC"),

)
def orchestrate():

    @task
    def ingest_cdc():
        w = WorkspaceClient(
            host="",
            token = ""

        )

        job_trigger = w.jobs.run_now(job_id="738604000864116")
        run_id = job_trigger.run_id
        start_time = time.monotonic()
        timeout_seconds = 3600
        while True:
            job_status = w.jobs.get_run(run_id=run_id)
            state = job_status.state
            print(
                f"Run ID: {run_id}, "
                f"Lifecycle: {state.life_cycle_state}, "
                f"Result: {state.result_state}"
            )
            if state.life_cycle_state in [RunLifeCycleState.TERMINATED, RunLifeCycleState.SKIPPED, RunLifeCycleState.INTERNAL_ERROR]:
                if state.result_state == RunResultState.SUCCESS:
                    print("Job completed successfully.")
                    break
                
                raise Exception(
                f"Databricks job failed. "
                f"Lifecycle: {state.life_cycle_state}; "
                f"Result: {state.result_state}"
                )    
            if time.monotonic() - start_time > timeout_seconds:
                raise TimeoutError(
                    f"Databricks run {run_id} did not finish within 1 hour."
                )
            time.sleep(5)

    source_freshness = BashOperator(
        task_id="source_freshness",
        cwd="/opt/airflow/walmart_project",
        bash_command="dbt source freshness --no-partial-parse",
    )

    silver_tech = BashOperator(
        task_id="silver_tech",
        cwd="/opt/airflow/walmart_project",
        bash_command="dbt run --select silver_tech --no-partial-parse",
    )

    silver_tech_test = BashOperator(
        task_id="silver_tech_test",
        cwd="/opt/airflow/walmart_project",
        bash_command="dbt test --select silver_tech --no-partial-parse",
    )

    silver_business = BashOperator(
        task_id="silver_business",
        cwd="/opt/airflow/walmart_project",
        bash_command="dbt run --select silver_business --no-partial-parse",
    )

    silver_business_test = BashOperator(
        task_id="silver_business_test",
        cwd="/opt/airflow/walmart_project",
        bash_command="dbt test --select silver_business --no-partial-parse",
    )

    gold_ephemeral = BashOperator(
        task_id="gold_ephemeral",
        cwd="/opt/airflow/walmart_project",
        bash_command="dbt run --select gold.ephemeral --no-partial-parse",
    )

    gold_dimension = BashOperator(
        task_id="gold_dimension",
        cwd="/opt/airflow/walmart_project",
        bash_command="dbt snapshot --no-partial-parse",
    )

    gold_fact = BashOperator(
        task_id="gold_fact",
        cwd="/opt/airflow/walmart_project",
        bash_command="dbt run --select gold.fact --no-partial-parse",
    )

    (
        ingest_cdc()
        >> source_freshness
        >> silver_tech
        >> silver_tech_test
        >> silver_business
        >> silver_business_test
        >> gold_ephemeral
        >> gold_dimension
        >> gold_fact
    )


orchestrate_dag = orchestrate()
