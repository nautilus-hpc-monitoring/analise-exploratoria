set.seed(13)

qtd_nodes <- 5
qtd_linhas <- 24 * 60 * 60 / 10
total_linhas <- qtd_nodes * qtd_linhas

limitar <- function(x, minimo, maximo) pmin(pmax(x, minimo), maximo)

HOSTNAME <- rep(
  paste0("node-0", 1:qtd_nodes),
  each = qtd_linhas
)

USER <- rep("root", total_linhas)

horarios <- seq(
  as.POSIXct("2026-10-23 00:00:00"),
  by = "10 sec",
  length.out = qtd_linhas
)

TIMESTAMP <- rep(
  format(horarios, "%Y-%m-%d %H:%M:%S"),
  times = qtd_nodes
)

CPU_PERCENT <- round(limitar(rnorm(total_linhas, mean = 52, sd = 22), 0.5, 100), 2)

CPU_USER_PERCENT   <- round(CPU_PERCENT * runif(total_linhas, 0.65, 0.75), 2)
CPU_SYSTEM_PERCENT <- round(CPU_PERCENT * runif(total_linhas, 0.15, 0.25), 2)
CPU_IDLE_PERCENT   <- round(100 - CPU_PERCENT, 2)

CPU_IOWAIT_PERCENT <- round(limitar(rexp(total_linhas, rate = 1 / 1.5), 0, 15), 2)

CPU_FREQ_ATUAL <- round(limitar(rnorm(total_linhas, mean = 2900, sd = 450), 1800, 3400), 2)

CPU_COUNT_LOGICA <- rep(128L, total_linhas)

LOAD_AVG_1  <- round(CPU_PERCENT / 100 * 128 + runif(total_linhas, 0.1, 2.0), 2)
LOAD_AVG_5  <- round(LOAD_AVG_1 * runif(total_linhas, 0.80, 0.90), 2)
LOAD_AVG_15 <- round(LOAD_AVG_1 * runif(total_linhas, 0.70, 0.80), 2)

RAM_PERCENT <- round(limitar(rbeta(total_linhas, 2.2, 3.5) * 100, 5, 95), 2)

RAM_TOTAL     <- rep(512, total_linhas)
RAM_USED      <- round(RAM_TOTAL * RAM_PERCENT / 100, 2)
RAM_AVAILABLE <- round(RAM_TOTAL - RAM_USED, 2)

SWAP_PERCENT <- round(
  ifelse(
    RAM_PERCENT >= 70,
    runif(total_linhas, 5, 30),
    limitar(rexp(total_linhas, rate = 1 / 1.5), 0, 6)
  ),
  2
)

SWAP_TOTAL <- 128
SWAP_USED  <- round(SWAP_TOTAL * SWAP_PERCENT / 100, 2)
SWAP_FREE  <- round(SWAP_TOTAL - SWAP_USED, 2)

gerar_swap_io <- function(n) {
  ativo <- runif(n) > 0.65
  round(ifelse(ativo, limitar(rexp(n, rate = 1 / 6), 0.01, 25), 0), 2)
}

SWAP_IN  <- gerar_swap_io(total_linhas)
SWAP_OUT <- gerar_swap_io(total_linhas)

DISCO_PERCENT <- round(limitar(rnorm(total_linhas, mean = 55, sd = 17), 20, 95), 2)

DISCO_TOTAL <- rep(2000, total_linhas)
DISCO_USED  <- round(DISCO_TOTAL * DISCO_PERCENT / 100, 2)
DISCO_FREE  <- round(DISCO_TOTAL - DISCO_USED, 2)

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