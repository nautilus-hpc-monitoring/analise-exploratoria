set.seed(13)

HOSTNAME <- rep(paste0("node-0", 1:8), each = 10)
USER <- rep("root", 80)

horarios <- seq(
  as.POSIXct("2026-10-23 08:00:00"),
  by = "10 min",
  length.out = 10
)

TIMESTAMP <- rep(
  format(horarios, "%Y-%m-%d %H:%M:%S"),
  times = 8
)

CPU_PERCENT <- sample(
  c(15, 25, 35, 45, 55, 65, 75, 85, 95),
  80, replace = TRUE,
  prob = c(8, 12, 15, 15, 15, 12, 10, 8, 5)
)

CPU_USER_PERCENT <- round(CPU_PERCENT * 0.70, 1)
CPU_SYSTEM_PERCENT <- round(CPU_PERCENT * 0.20, 1)
CPU_IDLE_PERCENT <- 100 - CPU_PERCENT

CPU_IOWAIT_PERCENT <- sample(
  c(0, 1, 2, 5, 10),
  80, replace = TRUE,
  prob = c(45, 25, 15, 10, 5)
)

CPU_FREQ_ATUAL <- sample(
  c(1800, 2200, 2600, 3000, 3400),
  80, replace = TRUE,
  prob = c(10, 20, 30, 25, 15)
)

CPU_COUNT_LOGICA <- rep(128, 80)

LOAD_AVG_1 <- round(
  CPU_PERCENT / 100 * 128 +
    sample(1:20, 80, replace = TRUE) / 10,
  2
)

LOAD_AVG_5 <- round(LOAD_AVG_1 * 0.85, 2)
LOAD_AVG_15 <- round(LOAD_AVG_1 * 0.75, 2)

RAM_PERCENT <- sample(
  c(10, 20, 30, 40, 50, 60, 70, 80, 90),
  80, replace = TRUE,
  prob = c(15, 20, 20, 15, 12, 8, 5, 3, 2)
)

RAM_TOTAL <- rep(512, 80)
RAM_USED <- round(RAM_TOTAL * RAM_PERCENT / 100, 1)
RAM_AVAILABLE <- RAM_TOTAL - RAM_USED

SWAP_PERCENT <- ifelse(
  RAM_PERCENT >= 70,
  sample(
    c(5, 10, 20, 30),
    80, replace = TRUE,
    prob = c(40, 30, 20, 10)
  ),
  sample(
    c(0, 1, 2, 5),
    80, replace = TRUE,
    prob = c(50, 25, 15, 10)
  )
)

SWAP_USED <- round(128 * SWAP_PERCENT / 100, 1)
SWAP_FREE <- 128 - SWAP_USED

SWAP_IN <- sample(
  c(0, 1, 5, 10, 20),
  80, replace = TRUE,
  prob = c(65, 15, 10, 7, 3)
)

SWAP_OUT <- sample(
  c(0, 1, 5, 10, 20),
  80, replace = TRUE,
  prob = c(65, 15, 10, 7, 3)
)

DISCO_PERCENT <- sample(
  c(20, 30, 40, 50, 60, 70, 80, 90),
  80, replace = TRUE,
  prob = c(5, 10, 20, 20, 18, 12, 10, 5)
)

DISCO_TOTAL <- rep(2000, 80)
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

head(dados_hpc)

write.csv(
  dados_hpc,
  "amostra_hpc.csv",
  row.names = FALSE
)
