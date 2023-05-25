## Prepping data for modeling
library(dplyr)
library(here)
library(readr)

load(here("data/complete_canopy_2023.RData"))

## some manipulation of variables to make sure the code below works consistently from last year

features_df <- full %>%
  select(
    # school characteristics
    school_id,
    grades_prek, grades_elementary, grades_middle, grades_high, 
    rural = self_reported_locale_rural, 
    suburban = self_reported_locale_suburban, 
    urban = self_reported_locale_urban,
    school_descriptor,
    
    # demographics
    teaching_diversity,
    leadership_diversity,
    self_reported_race_black, self_reported_race_hispanic, self_reported_race_white,
    self_reported_ell, self_reported_frpl, self_reported_swd,
    self_reported_total_enrollment
    
  ) %>%
  mutate(
    self_reported_bipoc = 1 - self_reported_race_white,
    across(starts_with("self_reported"), scale, .names = "scaled_{.col}"),
    across(starts_with("grades"), as.integer),
    across(ends_with("diversity"), factor)
  ) %>% 
  filter(teaching_diversity != 5) %>% 
  select(-starts_with("self_reported"))

levels(features_df$teaching_diversity) <- c("Prefer not to say", "<25% POC", "25-49% POC", "50-74% POC", ">74% POC", "Not sure")
levels(features_df$leadership_diversity) <- c("Prefer not to say", "<25% POC", "25-49% POC", "50-74% POC", ">74% POC")

write_rds(features_df, file = here("data/features_for_models.rds"))
