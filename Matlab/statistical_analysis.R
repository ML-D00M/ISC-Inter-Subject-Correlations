
# Load some packages that we will need
library(rstatix)
library(ggplot2)
library(ggpubr)
library(R.matlab)

setwd("E:/PAOLO/_Akimov Pilots")

# Load the data from the first group/condition (as sum of the 3 strongest components)
h_spb=readMat('h_spb_ISC_persubject_sum.mat')$ISC.persubject
h_spb=as.vector(h_spb)

# Boulevard
b_spb=readMat('b_spb_ISC_persubject_sum.mat')$ISC.persubject
b_spb=as.vector(b_spb)

# Load the data from the second group/condition (as sum of the 3 strongest components)
p_spb=readMat('p_spb_ISC_persubject_sum.mat')$ISC.persubject
p_spb=as.vector(p_spb)

# Moscow

# Load the data from the first group/condition (as sum of the 3 strongest components)
h_msk=readMat('h_msk_ISC_persubject_sum.mat')$ISC.persubject
h_msk=as.vector(h_msk)

# Load the data from the first group/condition (as sum of the 3 strongest components)
b_msk=readMat('b_msk_ISC_persubject_sum.mat')$ISC.persubject
b_msk=as.vector(b_msk)

# Load the data from the second group/condition (as sum of the 3 strongest components)
p_msk=readMat('p_msk_ISC_persubject_sum.mat')$ISC.persubject
p_msk=as.vector(p_msk)

# Load the data from the first group/condition (as sum of the 3 strongest components)
mov=readMat('mov_ISC_persubject_sum.mat')$ISC.persubject
mov=as.vector(mov)

# Load the data from the second group/condition (as sum of the 3 strongest components)
sea=readMat('sea_ISC_persubject_sum.mat')$ISC.persubject
sea=as.vector(sea)

t.test(mov,sea,paired=T)

# Movie vs Sea
df_ms=data.frame('ISC'=c(mov,sea),
              'condition'=c(rep('movie', length(mov)),
                            rep('sea', length(sea))),
              'id'=c(rep(1:length(mov),2)))

Nsubs=length(h_msk)
df=data.frame('ISC'=c(h_msk,b_msk,p_msk,h_spb,b_spb,p_spb),
              'condition'=c(rep(c(rep('highway', Nsubs),
                            rep('boulevard', Nsubs),
                            rep('park', Nsubs)),2)),
              'id'=c(rep(1:Nsubs,6)),
              'city'=c(rep('Moscow',Nsubs*3),rep('SPB',Nsubs*3)))
df$condition=factor(df$condition,levels=c('highway','park','boulevard'))



########## For a within-subjects analysis (Pavel) ##########

# Visualization
ggpaired(df, x = "condition", y = "ISC", fill='steelblue',
         point.size=2)+
  ylab('ISC')+
  theme(text = element_text(size=30),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=20))

ggbarplot(df, x = "condition", y = "ISC", error.plot = 'upper_errorbar',
          add = c("mean_se"), add.params = list(size=1), fill='steelblue')+
  geom_jitter(size=2, width=0.1)+
  theme(text = element_text(size=30),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=20))

# Statistics
df %>%
  group_by(condition) %>%
  shapiro_test(ISC)

#res.aov <- anova_test(data = df, dv = ISC, wid = id, within = condition)
#get_anova_table(res.aov)

#pwc <- df %>%
#  pairwise_t_test(
#    ISC ~ condition, paired = TRUE,
#    p.adjust.method = "none"
#  )
#pwc

stat.test = df %>%
  t_test(ISC ~ condition, paired = TRUE)
stat.test

# Report
#pwc = pwc %>% add_xy_position(x = "condition")
stat.test=stat.test %>% add_xy_position(x = "condition")
ggbarplot(df, x = "condition", y = "ISC", error.plot = 'upper_errorbar',
          add = c("mean_se"), add.params = list(size=1), fill='steelblue')+
  geom_jitter(size=2, width=0.1)+
  labs(subtitle = get_test_label(stat.test, detailed = F))+
  theme(text = element_text(size=30),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=20))

# another visualization
ggpaired(df, x = "condition", y = "ISC", fill='steelblue',
         point.size=2)+
  ylab('ISC')+
  labs(subtitle = get_test_label(stat.test, detailed = F))+
  theme(text = element_text(size=30),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=20))


# Visualization
ggbarplot(df, x = "city", y = "ISC", fill='condition',
          error.plot = 'upper_errorbar',
          position = position_dodge(width=0.8),
          add = c("mean_se"), add.params = list(size=1))+
  scale_fill_hue(l=40, c=35)+
  theme(text = element_text(size=30),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=20))

# Statistics
df %>%
  group_by(condition) %>%
  shapiro_test(ISC)

res.aov <- anova_test(
  data = df, dv = ISC, wid = id,
  within = c(city, condition)
)
get_anova_table(res.aov)


# Pairwise comparisons between treatment groups
pwc <- df %>%
  group_by(city) %>%
  pairwise_t_test(
    ISC ~ condition, paired = TRUE,
    p.adjust.method = "none"
  )
pwc


# Report
pwc = pwc %>% add_xy_position(x = "city")
ggbarplot(df, x = "city", y = "ISC", fill='condition',
          error.plot = 'upper_errorbar',
          position = position_dodge(width=0.8),
          add = c("mean_se"), add.params = list(size=1))+
  scale_fill_hue(l=40, c=35)+
  labs(subtitle = get_test_label(res.aov, detailed = F))+
  stat_pvalue_manual(pwc, tip.length = 0, size=8,
                     step.increase = 0.1,
                     bracket.size=1.5, hide.ns = T) +
  theme(text = element_text(size=20),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=10))


# Same but with cities collapsed

new_df=df[which(df$city=='SPB'),1:3]
for(i in df$id){
  for(cond in df$condition){
    thisISC=df[intersect(which(df$id==i),which(df$condition==cond)),1]
    new_df$ISC[intersect(which(new_df$id==i), which(new_df$condition==cond))]=mean(thisISC)
  }
}
str(new_df)

# Visualization
ggbarplot(new_df, x = "condition", y = "ISC", fill='condition',
          error.plot = 'upper_errorbar',
          position = position_dodge(width=0.8),
          add = c("mean_se"), add.params = list(size=1))+
  scale_fill_hue(l=40, c=35)+
  theme(text = element_text(size=30),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=20))

# Statistics
new_df %>%
  group_by(condition) %>%
  shapiro_test(ISC)

res.aov <- anova_test(
  data = new_df, dv = ISC, wid = id,
  within = condition
)
get_anova_table(res.aov)


# Pairwise comparisons between treatment groups
pwc <- new_df %>%
  pairwise_t_test(
    ISC ~ condition, paired = TRUE,
    p.adjust.method = "none"
  )
pwc


# Report
pwc = pwc %>% add_xy_position(x = "condition")
ggbarplot(df, x = "condition", y = "ISC", fill='condition',
          error.plot = 'upper_errorbar',
          position = position_dodge(width=0.8),
          add = c("mean_se"), add.params = list(size=1))+
  scale_fill_hue(l=40, c=35)+
  labs(subtitle = get_test_label(res.aov, detailed = F))+
  stat_pvalue_manual(pwc, tip.length = 0, size=8,
                     step.increase = 0.1,
                     bracket.size=1.5, hide.ns = T) +
  theme(text = element_text(size=20),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=10))


# Compare the three conditions with sea and movie, as well

all_combined=rbind(new_df,df_ms)
summary(all_combined)
all_combined$condition=factor(all_combined$condition,
                              levels=c('sea','highway','park',
                                       'boulevard','movie'))
# Visualization
ggbarplot(all_combined, x = "condition", y = "ISC", fill='condition',
          error.plot = 'upper_errorbar',
          position = position_dodge(width=0.8),
          add = c("mean_se"), add.params = list(size=1))+
  scale_fill_hue(l=40, c=35)+
  theme(text = element_text(size=30),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=20))

# Statistics
all_combined %>%
  group_by(condition) %>%
  shapiro_test(ISC)

res.aov <- anova_test(
  data = all_combined, dv = ISC, wid = id,
  within = condition
)
get_anova_table(res.aov)


# Pairwise comparisons between treatment groups
pwc <- all_combined %>%
  pairwise_t_test(
    ISC ~ condition, paired = TRUE,
    p.adjust.method = "none"
  )
pwc


# Report
pwc = pwc %>% add_xy_position(x = "condition")
ggbarplot(all_combined, x = "condition", y = "ISC", fill='condition',
          error.plot = 'upper_errorbar',
          position = position_dodge(width=0.8),
          add = c("mean_se"), add.params = list(size=1))+
  scale_fill_hue(l=40, c=35)+
  labs(subtitle = get_test_label(res.aov, detailed = F))+
  stat_pvalue_manual(pwc, tip.length = 0, size=5,
                     step.increase = 0.1,
                     bracket.size=1.2, hide.ns = T) +
  theme(text = element_text(size=20),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=10))


# Compare the three conditions with sea only
df_s=data.frame('ISC'=c(sea),
                'condition'=c(rep('sea', length(sea))),
                'id'=c(rep(1:length(sea),1)))

sea_combined=rbind(new_df,df_s)
summary(sea_combined)
sea_combined$condition=factor(sea_combined$condition,
                              levels=c('sea','highway','park',
                                       'boulevard'))
# Visualization
ggbarplot(sea_combined, x = "condition", y = "ISC", fill='condition',
          error.plot = 'upper_errorbar',
          position = position_dodge(width=0.8),
          add = c("mean_se"), add.params = list(size=1))+
  scale_fill_hue(l=40, c=35)+
  theme(text = element_text(size=30),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=20))

# Statistics
sea_combined %>%
  group_by(condition) %>%
  shapiro_test(ISC)

res.aov <- anova_test(
  data = sea_combined, dv = ISC, wid = id,
  within = condition
)
get_anova_table(res.aov)


# Pairwise comparisons between treatment groups
pwc <- sea_combined %>%
  pairwise_t_test(
    ISC ~ condition, paired = TRUE,
    p.adjust.method = "none"
  )
pwc


# Report
pwc = pwc %>% add_xy_position(x = "condition")
ggbarplot(sea_combined, x = "condition", y = "ISC", fill='condition',
          error.plot = 'upper_errorbar',
          position = position_dodge(width=0.8),
          add = c("mean_se"), add.params = list(size=1))+
  scale_fill_hue(l=40, c=35)+
  labs(subtitle = get_test_label(res.aov, detailed = F))+
  stat_pvalue_manual(pwc, tip.length = 0, size=5,
                     step.increase = 0.1,
                     bracket.size=1.2, hide.ns = T) +
  theme(text = element_text(size=20),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=10))


########### compare all 6 urban videos without grouping by city ############

Nsubs=length(h_msk)
df_nocity=data.frame('ISC'=c(h_msk,h_spb,p_spb,p_msk,b_msk,b_spb),
              'condition'=c(rep('MSK Highway', Nsubs),
                            rep('SPB Highway', Nsubs),
                            rep('SPB Boulevard', Nsubs),
                            rep('MSK Park', Nsubs),
                            rep('MSK Boulevard', Nsubs),
                            rep('SPB Park', Nsubs)),
              'id'=c(rep(1:Nsubs,6)))
df_nocity$condition=factor(df_nocity$condition,levels=c('MSK Highway','SPB Highway','SPB Boulevard','MSK Boulevard','MSK Park','SPB Park'))

########## For a within-subjects analysis (Pavel) ##########

# Visualization
ggpaired(df_nocity, x = "condition", y = "ISC", fill='steelblue',
         point.size=2)+
  ylab('ISC')+
  theme(text = element_text(size=30),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=20))

ggbarplot(df_nocity, x = "condition", y = "ISC", error.plot = 'upper_errorbar',
          add = c("mean_se"), add.params = list(size=1), fill='steelblue')+
  geom_jitter(size=2, width=0.1)+
  theme(text = element_text(size=30),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=20))

# Statistics
df_nocity %>%
  group_by(condition) %>%
  shapiro_test(ISC)

stat.test = df_nocity %>%
  t_test(ISC ~ condition, paired = TRUE)
stat.test

# Report
#pwc = pwc %>% add_xy_position(x = "condition")
stat.test=stat.test %>% add_xy_position(x = "condition")
ggbarplot(df_nocity, x = "condition", y = "ISC", error.plot = 'upper_errorbar',
          add = c("mean_se"), add.params = list(size=1), fill='steelblue')+
  geom_jitter(size=2, width=0.1)+
  labs(subtitle = get_test_label(stat.test, detailed = F))+
  theme(text = element_text(size=30),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=20))

# another visualization
ggpaired(df_nocity, x = "condition", y = "ISC", fill='steelblue',
         point.size=2)+
  ylab('ISC')+
  labs(subtitle = get_test_label(stat.test, detailed = F))+
  theme(text = element_text(size=30),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=20))


# Visualization
ggbarplot(df_nocity, x = "condition", y = "ISC", fill='condition',
          error.plot = 'upper_errorbar',
          position = position_dodge(width=0.8),
          add = c("mean_se"), add.params = list(size=1))+
  scale_fill_hue(l=40, c=35)+
  theme(text = element_text(size=10),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=20))

# Statistics
df_nocity %>%
  group_by(condition) %>%
  shapiro_test(ISC)

res.aov <- anova_test(
  data = df_nocity, dv = ISC, wid = id,
  within = c(condition)
)
get_anova_table(res.aov)


# Pairwise comparisons between treatment groups
pwc <- df_nocity %>%
  #group_by(condition) %>%
  pairwise_t_test(
    ISC ~ condition, paired = TRUE,
    p.adjust.method = "none"
  )
pwc


# Report
pwc = pwc %>% add_xy_position(x = "condition")
ggbarplot(df_nocity, x = "condition", y = "ISC", fill='condition',
          error.plot = 'upper_errorbar',
          position = position_dodge(width=0.8),
          add = c("mean_se"), add.params = list(size=1))+
  scale_fill_hue(l=40, c=35)+
  labs(subtitle = get_test_label(res.aov, detailed = F))+
  stat_pvalue_manual(pwc, tip.length = 0, size=8,
                     step.increase = 0.1,
                     bracket.size=1.5, hide.ns = T) +
  theme(text = element_text(size=10),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=10)) +
  theme(legend.position = "none")



################## compare only MSK videos ###################

Nsubs=length(h_msk)
df_msk=data.frame('ISC'=c(h_msk,p_msk,b_msk),
                     'condition'=c(rep('MSK Highway', Nsubs),
                                   rep('MSK Park', Nsubs),
                                   rep('MSK Boulevard', Nsubs)),
                     'id'=c(rep(1:Nsubs,3)))
df_msk$condition=factor(df_msk$condition,levels=c('MSK Highway','MSK Park','MSK Boulevard'))

########## For a within-subjects analysis ##########

# Visualization
ggpaired(df_msk, x = "condition", y = "ISC", fill='steelblue',
         point.size=2)+
  ylab('ISC')+
  theme(text = element_text(size=30),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=20))

ggbarplot(df_msk, x = "condition", y = "ISC", error.plot = 'upper_errorbar',
          add = c("mean_se"), add.params = list(size=1), fill='steelblue')+
  geom_jitter(size=2, width=0.1)+
  theme(text = element_text(size=30),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=20))

# Statistics
df_msk %>%
  group_by(condition) %>%
  shapiro_test(ISC)

stat.test = df_msk %>%
  t_test(ISC ~ condition, paired = TRUE)
stat.test

# Report
#pwc = pwc %>% add_xy_position(x = "condition")
stat.test=stat.test %>% add_xy_position(x = "condition")
ggbarplot(df_msk, x = "condition", y = "ISC", error.plot = 'upper_errorbar',
          add = c("mean_se"), add.params = list(size=1), fill='steelblue')+
  geom_jitter(size=2, width=0.1)+
  labs(subtitle = get_test_label(stat.test, detailed = F))+
  theme(text = element_text(size=30),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=20))

# another visualization
ggpaired(df_msk, x = "condition", y = "ISC", fill='steelblue',
         point.size=2)+
  ylab('ISC')+
  labs(subtitle = get_test_label(stat.test, detailed = F))+
  theme(text = element_text(size=30),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=20))


# Visualization
ggbarplot(df_msk, x = "condition", y = "ISC", fill='condition',
          error.plot = 'upper_errorbar',
          position = position_dodge(width=0.8),
          add = c("mean_se"), add.params = list(size=1))+
  scale_fill_hue(l=40, c=35)+
  theme(text = element_text(size=10),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=20))

# Statistics
df_msk %>%
  group_by(condition) %>%
  shapiro_test(ISC)

res.aov <- anova_test(
  data = df_msk, dv = ISC, wid = id,
  within = c(condition)
)
get_anova_table(res.aov)


# Pairwise comparisons between treatment groups
pwc <- df_msk %>%
  #group_by(condition) %>%
  pairwise_t_test(
    ISC ~ condition, paired = TRUE,
    p.adjust.method = "none"
  )
pwc


# Report
pwc = pwc %>% add_xy_position(x = "condition")
ggbarplot(df_msk, x = "condition", y = "ISC", fill='condition',
          error.plot = 'upper_errorbar',
          position = position_dodge(width=0.8),
          add = c("mean_se"), add.params = list(size=1))+
  scale_fill_hue(l=40, c=35)+
  labs(subtitle = get_test_label(res.aov, detailed = F))+
  stat_pvalue_manual(pwc, tip.length = 0, size=8,
                     step.increase = 0.1,
                     bracket.size=1.5, hide.ns = T) +
  theme(text = element_text(size=10),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=10)) +
  theme(legend.position = "none")



######## compare only SPB videos ###################

Nsubs=length(h_msk)
df_spb=data.frame('ISC'=c(h_spb,b_spb,p_spb),
                     'condition'=c(rep('SPB Highway', Nsubs),
                                   rep('SPB Park', Nsubs),
                                   rep('SPB Boulevard', Nsubs)),
                     'id'=c(rep(1:Nsubs,3)))
df_spb$condition=factor(df_spb$condition,levels=c('SPB Highway','SPB Park','SPB Boulevard'))

########## For a within-subjects analysis ##########

# Visualization
ggpaired(df_spb, x = "condition", y = "ISC", fill='steelblue',
         point.size=2)+
  ylab('ISC')+
  theme(text = element_text(size=30),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=20))

ggbarplot(df_spb, x = "condition", y = "ISC", error.plot = 'upper_errorbar',
          add = c("mean_se"), add.params = list(size=1), fill='steelblue')+
  geom_jitter(size=2, width=0.1)+
  theme(text = element_text(size=30),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=20))

# Statistics
df_spb %>%
  group_by(condition) %>%
  shapiro_test(ISC)

stat.test = df_spb %>%
  t_test(ISC ~ condition, paired = TRUE)
stat.test

# Report
#pwc = pwc %>% add_xy_position(x = "condition")
stat.test=stat.test %>% add_xy_position(x = "condition")
ggbarplot(df_spb, x = "condition", y = "ISC", error.plot = 'upper_errorbar',
          add = c("mean_se"), add.params = list(size=1), fill='steelblue')+
  geom_jitter(size=2, width=0.1)+
  labs(subtitle = get_test_label(stat.test, detailed = F))+
  theme(text = element_text(size=30),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=20))

# another visualization
ggpaired(df_spb, x = "condition", y = "ISC", fill='steelblue',
         point.size=2)+
  ylab('ISC')+
  labs(subtitle = get_test_label(stat.test, detailed = F))+
  theme(text = element_text(size=30),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=20))


# Visualization
ggbarplot(df_spb, x = "condition", y = "ISC", fill='condition',
          error.plot = 'upper_errorbar',
          position = position_dodge(width=0.8),
          add = c("mean_se"), add.params = list(size=1))+
  scale_fill_hue(l=40, c=35)+
  theme(text = element_text(size=10),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=20))

# Statistics
df_spb %>%
  group_by(condition) %>%
  shapiro_test(ISC)

res.aov <- anova_test(
  data = df_spb, dv = ISC, wid = id,
  within = c(condition)
)
get_anova_table(res.aov)


# Pairwise comparisons between treatment groups
pwc <- df_spb %>%
  #group_by(condition) %>%
  pairwise_t_test(
    ISC ~ condition, paired = TRUE,
    p.adjust.method = "none"
  )
pwc


# Report
pwc = pwc %>% add_xy_position(x = "condition")
ggbarplot(df_spb, x = "condition", y = "ISC", fill='condition',
          error.plot = 'upper_errorbar',
          position = position_dodge(width=0.8),
          add = c("mean_se"), add.params = list(size=1))+
  scale_fill_hue(l=40, c=35)+
  labs(subtitle = get_test_label(res.aov, detailed = F))+
  stat_pvalue_manual(pwc, tip.length = 0, size=8,
                     step.increase = 0.1,
                     bracket.size=1.5, hide.ns = T) +
  theme(text = element_text(size=10),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=10)) +
  theme(legend.position = "none")

