set.seed(13)

qtd_nodes <- 5
qtd_linhas <- 24 * 60 * 60 / 10

HOSTNAME <- rep(
  paste0("node-0", 1:qtd_nodes),
  each = qtd_linhas
)

USER <- rep("root", qtd_nodes * qtd_linhas)

horarios <- seq(
  as.POSIXct("2026-10-23 00:00:00"),
  by = "10 sec",
  length.out = qtd_linhas
)

TIMESTAMP <- rep(
  format(horarios, "%Y-%m-%d %H:%M:%S"),
  times = qtd_nodes
)

total_linhas <- qtd_nodes * qtd_linhas

# CPU
CPU_PERCENT <- sample(
  c(15, 25, 35, 45, 55, 65, 75, 85, 95),
  total_linhas, replace = TRUE,
  prob = c(8, 12, 15, 15, 15, 12, 10, 8, 5)
)

CPU_USER_PERCENT <- round(CPU_PERCENT * 0.70, 1)
CPU_SYSTEM_PERCENT <- round(CPU_PERCENT * 0.20, 1)
CPU_IDLE_PERCENT <- 100 - CPU_PERCENT

CPU_IOWAIT_PERCENT <- sample(
  c(0, 1, 2, 5, 10),
  total_linhas, replace = TRUE,
  prob = c(45, 25, 15, 10, 5)
)

CPU_FREQ_ATUAL <- sample(
  c(1800, 2200, 2600, 3000, 3400),
  total_linhas, replace = TRUE,
  prob = c(10, 20, 30, 25, 15)
)

CPU_COUNT_LOGICA <- rep(128, total_linhas)

LOAD_AVG_1 <- round(
  CPU_PERCENT / 100 * 128 +
    sample(1:20, total_linhas, replace = TRUE) / 10,
  2
)

LOAD_AVG_5 <- round(LOAD_AVG_1 * 0.85, 2)
LOAD_AVG_15 <- round(LOAD_AVG_1 * 0.75, 2)

RAM_PERCENT <- sample(
  c(10, 20, 30, 40, 50, 60, 70, 80, 90),
  total_linhas, replace = TRUE,
  prob = c(15, 20, 20, 15, 12, 8, 5, 3, 2)
)

RAM_TOTAL <- rep(512, total_linhas)
RAM_USED <- round(RAM_TOTAL * RAM_PERCENT / 100, 1)
RAM_AVAILABLE <- RAM_TOTAL - RAM_USED

SWAP_PERCENT <- ifelse(
  RAM_PERCENT >= 70,
  sample(
    c(5, 10, 20, 30),
    total_linhas, replace = TRUE,
    prob = c(40, 30, 20, 10)
  ),
  sample(
    c(0, 1, 2, 5),
    total_linhas, replace = TRUE,
    prob = c(50, 25, 15, 10)
  )
)

SWAP_USED <- round(128 * SWAP_PERCENT / 100, 1)
SWAP_FREE <- 128 - SWAP_USED

SWAP_IN <- sample(
  c(0, 1, 5, 10, 20),
  total_linhas, replace = TRUE,
  prob = c(65, 15, 10, 7, 3)
)

SWAP_OUT <- sample(
  c(0, 1, 5, 10, 20),
  total_linhas, replace = TRUE,
  prob = c(65, 15, 10, 7, 3)
)

DISCO_PERCENT <- sample(
  c(20, 30, 40, 50, 60, 70, 80, 90),
  total_linhas, replace = TRUE,
  prob = c(5, 10, 20, 20, 18, 12, 10, 5)
)

DISCO_TOTAL <- rep(2000, total_linhas)
DISCO_USED <- round(DISCO_TOTAL * DISCO_PERCENT / 100, 1)
DISCO_FREE <- DISCO_TOTAL - DISCO_USED

dados_hpc <- data.frame(
  TIMESTAMP,
  HOSTNAME,
  USER,
  CPU_PERCENT,
  CPU_USER_PERCENT,
  CPU_SYSTEM_PERCENT,
  CPU_IDLE_PERCENT,
  CPU_IOWAIT_PERCENT,
  CPU_FREQ_ATUAL,
  CPU_COUNT_LOGICA,
  LOAD_AVG_1,
  LOAD_AVG_5,
  LOAD_AVG_15,
  RAM_PERCENT,
  RAM_TOTAL,
  RAM_AVAILABLE,
  RAM_USED,
  SWAP_PERCENT,
  SWAP_USED,
  SWAP_FREE,
  SWAP_IN,
  SWAP_OUT,
  DISCO_PERCENT,
  DISCO_TOTAL,
  DISCO_USED,
  DISCO_FREE
)

write.csv(
  dados_hpc,
  "amostra_hpc.csv",
  row.names = FALSE
)
