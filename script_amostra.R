set.seed(13)

qtd_nodes <- 5
qtd_linhas <- 24 * 60 * 60 / 10
total_linhas <- qtd_nodes * qtd_linhas

limitar <- function(x, minimo, maximo) pmin(pmax(x, minimo), maximo)

por_node <- function(valores) rep(valores, each = qtd_linhas)

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

cpu_media <- por_node(c(38, 52, 66, 47, 58))
cpu_sd    <- por_node(c(12, 20, 17, 28, 22))

CPU_PERCENT <- round(limitar(rnorm(total_linhas, mean = cpu_media, sd = cpu_sd), 0.5, 100), 2)

CPU_USER_PERCENT   <- round(CPU_PERCENT * runif(total_linhas, 0.65, 0.75), 2)
CPU_SYSTEM_PERCENT <- round(CPU_PERCENT * runif(total_linhas, 0.15, 0.25), 2)
CPU_IDLE_PERCENT   <- round(100 - CPU_PERCENT, 2)

iowait_escala <- por_node(c(1.0, 1.5, 2.0, 4.0, 1.5))
CPU_IOWAIT_PERCENT <- round(limitar(rexp(total_linhas, rate = 1 / iowait_escala), 0, 15), 2)

freq_media <- por_node(c(2500, 2900, 3150, 2700, 3000))
freq_sd    <- por_node(c(300, 450, 250, 500, 400))
CPU_FREQ_ATUAL <- round(limitar(rnorm(total_linhas, mean = freq_media, sd = freq_sd), 1800, 3400), 2)

CPU_COUNT_LOGICA <- rep(128L, total_linhas)

LOAD_AVG_1  <- round(CPU_PERCENT / 100 * 128 + runif(total_linhas, 0.1, 2.0), 2)
LOAD_AVG_5  <- round(LOAD_AVG_1 * runif(total_linhas, 0.80, 0.90), 2)
LOAD_AVG_15 <- round(LOAD_AVG_1 * runif(total_linhas, 0.70, 0.80), 2)

ram_a <- por_node(c(2.0, 2.2, 3.5, 1.5, 4.0))
ram_b <- por_node(c(5.0, 3.5, 2.5, 3.0, 2.5))
RAM_PERCENT <- round(limitar(rbeta(total_linhas, ram_a, ram_b) * 100, 5, 95), 2)

RAM_TOTAL     <- rep(512, total_linhas)
RAM_USED      <- round(RAM_TOTAL * RAM_PERCENT / 100, 2)
RAM_AVAILABLE <- round(RAM_TOTAL - RAM_USED, 2)

swap_escala <- por_node(c(0.8, 1.5, 2.0, 1.2, 3.0))
SWAP_PERCENT <- round(
  ifelse(
    RAM_PERCENT >= 70,
    runif(total_linhas, 5, 30),
    limitar(rexp(total_linhas, rate = 1 / swap_escala), 0, 6)
  ),
  2
)

SWAP_TOTAL <- 128
SWAP_USED  <- round(SWAP_TOTAL * SWAP_PERCENT / 100, 2)
SWAP_FREE  <- round(SWAP_TOTAL - SWAP_USED, 2)

swap_prob_ativo <- por_node(c(0.20, 0.35, 0.45, 0.30, 0.55))

gerar_swap_io <- function(n) {
  ativo <- runif(n) < swap_prob_ativo
  round(ifelse(ativo, limitar(rexp(n, rate = 1 / 6), 0.01, 25), 0), 2)
}

SWAP_IN  <- gerar_swap_io(total_linhas)
SWAP_OUT <- gerar_swap_io(total_linhas)

disco_media <- por_node(c(42, 55, 68, 50, 62))
disco_sd    <- por_node(c(10, 17, 9, 20, 14))
DISCO_PERCENT <- round(limitar(rnorm(total_linhas, mean = disco_media, sd = disco_sd), 20, 95), 2)

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