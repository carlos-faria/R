cpus = 1:8
parallelPctg_array = c(.4, .8, .85, .9, .95, .98, .99)
sequentialPctg_array = 1 - parallelPctg
len_df = length(parallelPctg_array)

df_list =  vector("list", len_df) 
for (i in 1:len_df){
  df <- data.frame('cpu' = cpus,
                   'parallelPctg' = parallelPctg_array[[i]],
                   'sequentialPctg' = sequentialPctg_array[[i]])
  df$speedup <- with(df, 1 / (sequentialPctg + parallelPctg/cpu))
  df$efficiency <- with(df, speedup/cpu)
  df_list[[i]] <- df
} 

access <- function(index, column) df_list[[index]][column]
speedup_df <- data.frame(lapply(1:len_df, access, 'speedup'))
names(speedup_df) <- sprintf('%.0f%%', 100*parallelPctg)

library(ggplot2)

speedup_df$cpu <- cpus
molten_df <- reshape2::melt(speedup_df, id.vars='cpu')
ggplot(molten_df, aes(x=cpu, y=value, col=variable)) + 
  geom_line()






