#!/bin/bash

VALORES=(10000 100000 1000000)
CONTAINER_NAME="cassandraDB"

echo "====================================================="
echo " BENCHMARK - APACHE CASSANDRA "
echo "====================================================="

for val in "${VALORES[@]}"; do
    echo ""
    echo ">>> A iniciar o conjunto de testes para VALUE = $val registos <<<"
    echo "------------------------------------------------------------"

    # 1. Fase de Carga Inicial (Load)
    echo "[1/7] A carregar dados iniciais (Load - Workload A)..."
    python2 ./bin/ycsb load cassandra-cql -p hosts=127.0.0.1 -P workloads/workloada -p recordcount=$val -s > load_cassandra_${val}.txt

    # 2. Workloads Regulares (A, B, C, F, D)
    echo "[2/7] A executar Workload A (50% Read / 50% Update)..."
    python2 ./bin/ycsb run cassandra-cql -p hosts=127.0.0.1 -P workloads/workloada -p recordcount=$val -p operationcount=$val -s > run_cassandra_workloadA_${val}.txt

    echo "[3/7] A executar Workload B (95% Read / 5% Update)..."
    python2 ./bin/ycsb run cassandra-cql -p hosts=127.0.0.1 -P workloads/workloadb -p recordcount=$val -p operationcount=$val -s > run_cassandra_workloadB_${val}.txt

    echo "[4/7] A executar Workload C (100% Read)..."
    python2 ./bin/ycsb run cassandra-cql -p hosts=127.0.0.1 -P workloads/workloadc -p recordcount=$val -p operationcount=$val -s > run_cassandra_workloadC_${val}.txt

    echo "[5/7] A executar Workload F (Read-Modify-Write)..."
    python2 ./bin/ycsb run cassandra-cql -p hosts=127.0.0.1 -P workloads/workloadf -p recordcount=$val -p operationcount=$val -s > run_cassandra_workloadF_${val}.txt

    echo "[6/7] A executar Workload D (Read Latest / Inserts)..."
    python2 ./bin/ycsb run cassandra-cql -p hosts=127.0.0.1 -P workloads/workloadd -p recordcount=$val -p operationcount=$val -s > run_cassandra_workloadD_${val}.txt

    # 3. Limpeza para o Workload E
    echo "[INFO] A limpar a base de dados (TRUNCATE) para o Workload E..."
    docker exec -i $CONTAINER_NAME cqlsh -e "TRUNCATE ycsb.usertable;"
    sleep 5

    # 4. Workload E (Load e Run)
    echo "[7/7] A carregar e executar Workload E (Short Ranges)..."
    python2 ./bin/ycsb load cassandra-cql -p hosts=127.0.0.1 -P workloads/workloade -p recordcount=$val -s > load_cassandra_workloadE_${val}.txt
    
    python2 ./bin/ycsb run cassandra-cql -p hosts=127.0.0.1 -P workloads/workloade -p recordcount=$val -p operationcount=$val -s > run_cassandra_workloadE_${val}.txt

    # 5. Limpeza final
    echo "[INFO] Ciclo de $val concluído. A limpar a base de dados para a próxima iteração..."
    docker exec -i $CONTAINER_NAME cqlsh -e "TRUNCATE ycsb.usertable;"
    sleep 5

    echo ">>> Testes para $val concluídos com sucesso! <<<"
done

echo "====================================================="
echo " TODOS OS TESTES FORAM CONCLUÍDOS! "
echo "====================================================="
