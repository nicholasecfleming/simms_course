# Taken from the help(simmr_elicit) file

# Clear workspace and load in packages
rm(list = ls())
library(simmr)

# (Fake) data set: 10 observations, 2 tracers, 4 sources
mix = matrix(c(-10.13, -10.72, -11.39, -11.18, -10.81, -10.7, -10.54, 
               -10.48, -9.93, -9.37, 11.59, 11.01, 10.59, 10.97, 11.52, 11.89, 
               11.73, 10.89, 11.05, 12.3), ncol=2, nrow=10)
colnames(mix) = c('d13C','d15N')
s_names=c('Source A','Source B','Source C','Source D')
s_means = matrix(c(-14, -15.1, -11.03, -14.44, 3.06, 7.05, 13.72, 5.96), ncol=2, nrow=4)
s_sds = matrix(c(0.48, 0.38, 0.48, 0.43, 0.46, 0.39, 0.42, 0.48), ncol=2, nrow=4)
c_means = matrix(c(2.63, 1.59, 3.41, 3.04, 3.28, 2.34, 2.14, 2.36), ncol=2, nrow=4)
c_sds = matrix(c(0.41, 0.44, 0.34, 0.46, 0.46, 0.48, 0.46, 0.66), ncol=2, nrow=4)
conc = matrix(c(0.02, 0.1, 0.12, 0.04, 0.02, 0.1, 0.09, 0.05), ncol=2, nrow=4)

# Load into simmr
simmr_1 = simmr_load(mixtures=mix,
                     source_names=s_names,
                     source_means=s_means,
                     source_sds=s_sds,
                     correction_means=c_means,
                     correction_sds=c_sds,
                     concentration_means = conc)

# Iso-space plot
plot(simmr_1)

# MCMC run - do this for comparison (you don't need to run this before the elicit command)
simmr_1_out = simmr_mcmc(simmr_1)

# Summary
summary(simmr_1_out,'quantiles')
# A bit vague:
#           2.5
# Source A 0.029 0.115 0.203 0.312 0.498
# Source B 0.146 0.232 0.284 0.338 0.453
# Source C 0.216 0.255 0.275 0.296 0.342
# Source D 0.032 0.123 0.205 0.299 0.465

# Now suppose I had prior information that: 
# proportion means = 0.5,0.2,0.2,0.1 
# proportion sds = 0.08,0.02,0.01,0.02
prior=simmr_elicit(n_sources = 4,
                   c(0.5,0.2,0.2,0.1),
                   c(0.08,0.02,0.01,0.02))

simmr_1a_out = simmr_mcmc(simmr_1,
                          prior_control=list(means=prior$mean,
                                             sd=prior$sd))

summary(simmr_1a_out,'quantiles')
# Much more precise:
#           2.5
# Source A 0.441 0.494 0.523 0.553 0.610
# Source B 0.144 0.173 0.188 0.204 0.236
# Source C 0.160 0.183 0.196 0.207 0.228
# Source D 0.060 0.079 0.091 0.105 0.135
