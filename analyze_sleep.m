addpath('D:\Gits\Spindle_analysis\V2.0')
load('Stages.mat')
load('Arousals.mat')

idx_cue     = find(contains(out_sleepstages.Properties.VariableNames, ...
    'Cue'));
idx_placebo = find(contains(out_sleepstages.Properties.VariableNames, ...
    'Placebo'));

all_cue_stage           = out_sleepstages{:, idx_cue};
all_placebo_stage       = out_sleepstages{:, idx_placebo};
all_cue_arousals        = out_arousals{:, idx_cue};
all_placebo_arousals    = out_arousals{:, idx_placebo};

sleepscorelabels = {    ...
    'Awake',    0;      ...
    'REM',      5;      ...
    'NREM1',    1;      ...
    'NREM2',    2;      ...
    'NREM3',    3;      ...
    'NREM4',    4;      ...
    'MT',       8       };


%% Cue night
for i_sub = 1:size(all_cue_stage,2)
   
    valid_scores            = all_cue_stage(~isnan(all_cue_stage(:,i_sub)),i_sub);
    non_awake               = find(valid_scores ~= 0);
    sleep_onset(i_sub)      = non_awake(1);
    total_scores(i_sub)     = numel(valid_scores);
    total_awake(i_sub)      = numel(valid_scores(valid_scores == 0));
    total_nrem1(i_sub)      = numel(valid_scores(valid_scores == 1));
    total_nrem2(i_sub)      = numel(valid_scores(valid_scores == 2));
    total_nrem3(i_sub)      = numel(valid_scores(valid_scores == 3));
    total_nrem4(i_sub)      = numel(valid_scores(valid_scores == 4));
    total_sws(i_sub)        = total_nrem3(i_sub) + total_nrem4(i_sub);
    total_rem(i_sub)        = numel(valid_scores(valid_scores == 5));
    total_mt(i_sub)         = numel(valid_scores(valid_scores == 8));
    total_arousals(i_sub)   = numel(find(all_cue_arousals(:, i_sub) == 1));
    non_mt                  = find(valid_scores ~= 8);
    total_sleep(i_sub)      = numel(intersect(non_awake, non_mt));
    
    j = 1;
    for i_sc = 1:numel(valid_scores)
    	if valid_scores(i_sc) == 0
            j = j + 1;
        else
            break
        end
    end
    all_awake = find(valid_scores == 0);
    total_waso(i_sub)       = numel(all_awake(all_awake > j));
    
    xvector = 1:numel(valid_scores);
    plot(xvector * 30 / 60, -valid_scores)
    
end

cue.perc_nrem1              = total_nrem1   .* 100 ./ total_scores;
cue.perc_nrem2              = total_nrem2   .* 100 ./ total_scores;
cue.perc_nrem3              = total_nrem3   .* 100 ./ total_scores;
cue.min_nrem3               = total_nrem3   .* 30 ./ 60; % 30s scores
cue.perc_nrem4              = total_nrem4   .* 100 ./ total_scores;
cue.min_nrem4               = total_nrem4   .* 30 ./ 60; % 30s scores
cue.perc_sws                = total_sws     .* 100 ./ total_scores;
cue.min_sws                 = total_sws     .* 30 ./ 60; % 30s scores
cue.perc_rem                = total_rem     .* 100 ./ total_scores;
cue.perc_waso               = total_waso    .* 100 ./ total_scores;
cue.min_waso                = total_waso    .* 30 ./ 60;
cue.sleep_onset             = sleep_onset   .* 30 ./ 60;
cue.perc_sleep              = total_sleep   .* 100 ./ total_scores;
cue.min_sleep               = total_sleep   .* 30 ./ 60;
cue.num_mt                  = total_mt;
cue.num_arousals            = total_arousals;
cue.efficiency              = cue.min_sleep .*100 ./ ...
    (total_scores .* 30 ./ 60);


%% Placebo night
for i_sub = 1:size(all_placebo_stage,2)
   
    valid_scores            = all_placebo_stage(~isnan(all_placebo_stage(:,i_sub)),i_sub);
    non_awake               = find(valid_scores ~= 0);
    sleep_onset(i_sub)      = non_awake(1);
    total_scores(i_sub)     = numel(valid_scores);
    total_awake(i_sub)      = numel(valid_scores(valid_scores == 0));
    total_nrem1(i_sub)      = numel(valid_scores(valid_scores == 1));
    total_nrem2(i_sub)      = numel(valid_scores(valid_scores == 2));
    total_nrem3(i_sub)      = numel(valid_scores(valid_scores == 3));
    total_nrem4(i_sub)      = numel(valid_scores(valid_scores == 4));
    total_sws(i_sub)        = total_nrem3(i_sub) + total_nrem4(i_sub);
    total_rem(i_sub)        = numel(valid_scores(valid_scores == 5));
    total_mt(i_sub)         = numel(valid_scores(valid_scores == 8));
    total_arousals(i_sub)   = numel(find(all_placebo_arousals(:, i_sub) == 1));
    non_mt                  = find(valid_scores ~= 8);
    total_sleep(i_sub)      = numel(intersect(non_awake, non_mt));
    
    j = 1;
    for i_sc = 1:numel(valid_scores)
        if valid_scores(i_sc) == 0
            j = j + 1;
        else
            break
        end
    end
    all_awake = find(valid_scores == 0);
    total_waso(i_sub)       = numel(all_awake(all_awake > j));
    
    xvector = 1:numel(valid_scores);
    plot(xvector * 30 / 60, -valid_scores)
    
end

placebo.perc_nrem1              = total_nrem1   .* 100 ./ total_scores;
placebo.perc_nrem2              = total_nrem2   .* 100 ./ total_scores;
placebo.perc_nrem3              = total_nrem3   .* 100 ./ total_scores;
placebo.min_nrem3               = total_nrem3   .* 30 ./ 60; % 30s scores
placebo.perc_nrem4              = total_nrem4   .* 100 ./ total_scores;
placebo.min_nrem4               = total_nrem4   .* 30 ./ 60; % 30s scores
placebo.perc_sws                = total_sws     .* 100 ./ total_scores;
placebo.min_sws                 = total_sws     .* 30 ./ 60; % 30s scores
placebo.perc_rem                = total_rem     .* 100 ./ total_scores;
placebo.perc_waso               = total_waso    .* 100 ./ total_scores;
placebo.min_waso                = total_waso    .* 30 ./ 60;
placebo.sleep_onset             = sleep_onset   .* 30 ./ 60;
placebo.perc_sleep              = total_sleep   .* 100 ./ total_scores;
placebo.min_sleep               = total_sleep   .* 30 ./ 60;
placebo.num_mt                  = total_mt;
placebo.num_arousals            = total_arousals;
placebo.efficiency              = placebo.min_sleep .*100 ./ ...
    (total_scores .* 30 ./ 60);


%% Normality verification and stats
type_data = 'perc_nrem4';

figName = histogram(placebo.(type_data), ...
min(placebo.(type_data)):max(placebo.(type_data)));
hold on
figName = histogram(cue.(type_data), ...
    min(cue.(type_data)):max(cue.(type_data))); % Verifying normality
hold off

[figName, p_AreThereDifferences] = ...
    f_stats_ttest([cue.(type_data)', placebo.(type_data)'], ...
    figName, {'Cue', 'Placebo'}, [], 0, [], ...
    [], []);

mean(cue.(type_data))
std(cue.(type_data))
mean(placebo.(type_data))
std(placebo.(type_data))
p_AreThereDifferences
