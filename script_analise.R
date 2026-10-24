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

hist(df$CPU_PERCENT,
     main = "Distribuição da CPU",
     xlab = "Utilização (%)",
     col = "lightgray")
abline(v = mean(df$CPU_PERCENT), col = "red", lwd = 2)
abline(v = median(df$CPU_PERCENT), col = "blue", lwd = 2)

hist(df$RAM_PERCENT,
     main = "Distribuição da RAM",
     xlab = "Utilização (%)",
     col = "lightgray")
abline(v = mean(df$RAM_PERCENT), col = "red", lwd = 2)
abline(v = median(df$RAM_PERCENT), col = "blue", lwd = 2)

hist(df$SWAP_PERCENT,
     main = "Distribuição da SWAP",
     xlab = "Utilização (%)",
     col = "lightgray")
abline(v = mean(df$SWAP_PERCENT), col = "red", lwd = 2)
abline(v = median(df$SWAP_PERCENT), col = "blue", lwd = 2)

hist(df$DISCO_PERCENT,
     main = "Distribuição do disco",
     xlab = "Utilização (%)",
     col = "lightgray")
abline(v = mean(df$DISCO_PERCENT), col = "red", lwd = 2)
abline(v = median(df$DISCO_PERCENT), col = "blue", lwd = 2)

df$HOSTNAME <- factor(df$HOSTNAME)

vars <- c("CPU_PERCENT", "RAM_PERCENT", "SWAP_PERCENT", "DISCO_PERCENT")
titulos <- c(
  CPU_PERCENT   = "CPU",
  RAM_PERCENT   = "RAM",
  SWAP_PERCENT  = "SWAP",
  DISCO_PERCENT = "Disco"
)

medias <- aggregate(df[, vars], by = list(HOSTNAME = df$HOSTNAME), FUN = mean, na.rm = TRUE)
medias

medianas <- aggregate(df[, vars], by = list(HOSTNAME = df$HOSTNAME), FUN = median, na.rm = TRUE)
medianas

desvios <- aggregate(df[, vars], by = list(HOSTNAME = df$HOSTNAME), FUN = sd, na.rm = TRUE)
desvios


ggplot(df, aes(x = HOSTNAME, y = CPU_PERCENT, fill = HOSTNAME)) +
  geom_boxplot(outlier.alpha = 0.3) +
  stat_summary(fun = mean, geom = "point", shape = 23, size = 3, fill = "red") +
  labs(
    title = "Distribuição da CPU por node",
    x = "Node",
    y = "Utilização (%)"
  ) +
  theme_minimal() +
  theme(legend.position = "none")


ggplot(df, aes(x = HOSTNAME, y = RAM_PERCENT, fill = HOSTNAME)) +
  geom_boxplot(outlier.alpha = 0.3) +
  stat_summary(fun = mean, geom = "point", shape = 23, size = 3, fill = "red") +
  labs(
    title = "Distribuição da RAM por node",
    x = "Node",
    y = "Utilização (%)"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

ggplot(df, aes(x = HOSTNAME, y = SWAP_PERCENT, fill = HOSTNAME)) +
  geom_boxplot(outlier.alpha = 0.3) +
  stat_summary(fun = mean, geom = "point", shape = 23, size = 3, fill = "red") +
  labs(
    title = "Distribuição da SWAP por node",
    x = "Node",
    y = "Utilização (%)"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

ggplot(df, aes(x = HOSTNAME, y = DISCO_PERCENT, fill = HOSTNAME)) +
  geom_boxplot(outlier.alpha = 0.3) +
  stat_summary(fun = mean, geom = "point", shape = 23, size = 3, fill = "red") +
  labs(
    title = "Distribuição do disco por node",
    x = "Node",
    y = "Utilização (%)"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

cor(df$RAM_PERCENT, df$SWAP_PERCENT, method = "pearson")

cor(df$DISCO_PERCENT, df$SWAP_PERCENT, method = "pearson")

cor(df$RAM_PERCENT, df$CPU_PERCENT, method = "pearson")


modelo_ram_swap <- lm(SWAP_PERCENT ~ RAM_PERCENT, data = df)
summary(modelo_ram_swap)

plot(df$RAM_PERCENT, df$SWAP_PERCENT,
     xlab = "RAM_PERCENT", ylab = "SWAP_PERCENT",
     main = "Correlação: SWAP_PERCENT x RAM_PERCENT",
     pch = 16, col = rgb(0, 0, 0, 0.15))
abline(modelo_ram_swap, col = "red", lwd = 2)


node4 <- df[df$HOSTNAME == "node-04", ]

cor(node4$SWAP_IN, node4$CPU_IOWAIT_PERCENT, method = "pearson")

cor(node4$SWAP_OUT, node4$CPU_IOWAIT_PERCENT, method = "pearson")

  

modelo_out_iowait <- lm(CPU_IOWAIT_PERCENT ~ SWAP_OUT, data = node4)
summary(modelo_out_iowait)

plot(node4$SWAP_OUT, node4$CPU_IOWAIT_PERCENT,
     xlab = "SWAP_OUT", ylab = "CPU_IOWAIT_PERCENT",
     main = "node-04: CPU_IOWAIT_PERCENT x SWAP_OUT",
     pch = 16, col = rgb(0, 0, 0, 0.15))
abline(modelo_out_iowait, col = "red", lwd = 2)
