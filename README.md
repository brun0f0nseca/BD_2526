# 📊 Benchmark Cassandra vs ScyllaDB (YCSB)
Este repositório apresenta um conjunto de benchmarks realizados com recurso ao **Yahoo! Cloud Serving Benchmark (YCSB)**, para comparar o desempenho das bases de dados **Apache Cassandra** e **ScyllaDB**.
O objetivo principal é avaliar métricas como **throughput**, **latência** e **comportamento sob diferentes workloads**, num ambiente controlado.

---

## ⚙️ Ambiente de Testes
Os testes foram executados numa máquina virtual (Ubuntu) com a seguinte configuração:
* **CPU**: 2 vCPUs
* **RAM**: 2 GB
* **Armazenamento**: SSD (25 GB)
* **Ferramenta de Benchmark**: YCSB

---

## 🧪 Workloads Testados
Foram utilizados **6 cenários distintos** (fase de carga + 6 workloads padrão do YCSB):

| Workload   | Descrição                            |
| ---------- | ------------------------------------ |
| Load       | Inserção inicial de dados            |
| Workload A | 50% Reads / 50% Updates              |
| Workload B | 95% Reads / 5% Updates               |
| Workload C | 100% Reads                           |
| Workload D | 95% Reads / 5% Inserts               |
| Workload E | 95% Scans / 5% Inserts               |
| Workload F | 50% Reads / 50% Read-Modify-Write    |

---

## 🧠 Análise Técnica
As diferenças de desempenho observáveis, resultam principalmente das diferenças arquiteturais entre as duas bases de dados:

### Apache Cassandra
* Implementada em Java;
* Dependente da JVM (Garbage Collection);
* Modelo multi-thread tradicional.

### ScyllaDB
* Implementada em C++;
* Modelo **thread-per-core**;
* Arquitetura **lock-free**;
* I/O assíncrono otimizado.

---

## 👨‍💻 Autor
Bruno Fonseca
ISEC – Engenharia Informática

---
