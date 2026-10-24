df <- dados_hpc
head(df)

recursos <- df[, c(
  "CPU_PERCENT",
  "RAM_PERCENT",
  "SWAP_PERCENT",
  "DISCO_PERCENT"
)]

sapply(recursos, mean, na.rm = TRUE)

sapply(recursos, median, na.rm = TRUE)

sapply(recursos, sd, na.rm = TRUE)

hist(dados_hpc$CPU_PERCENT,
     main = "Distribuição da CPU",
     xlab = "Utilização (%)",
     col = "lightgray")
abline(v = mean(dados_hpc$CPU_PERCENT), col = "red", lwd = 2)
abline(v = median(dados_hpc$CPU_PERCENT), col = "blue", lwd = 2)

hist(dados_hpc$RAM_PERCENT,
     main = "Distribuição da RAM",
     xlab = "Utilização (%)",
     col = "lightgray")
abline(v = mean(dados_hpc$RAM_PERCENT), col = "red", lwd = 2)
abline(v = median(dados_hpc$RAM_PERCENT), col = "blue", lwd = 2)

hist(dados_hpc$SWAP_PERCENT,
     main = "Distribuição da SWAP",
     xlab = "Utilização (%)",
     col = "lightgray")
abline(v = mean(dados_hpc$SWAP_PERCENT), col = "red", lwd = 2)
abline(v = median(dados_hpc$SWAP_PERCENT), col = "blue", lwd = 2)

hist(dados_hpc$DISCO_PERCENT,
     main = "Distribuição do disco",
     xlab = "Utilização (%)",
     col = "lightgray")
abline(v = mean(dados_hpc$DISCO_PERCENT), col = "red", lwd = 2)
abline(v = median(dados_hpc$DISCO_PERCENT), col = "blue", lwd = 2)

