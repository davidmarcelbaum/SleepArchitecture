%% Parameters

load('.\GermanDatasets\Stages.mat')
load('.\GermanDatasets\Arousals.mat')

idx_odor = find(contains(out_sleepstages.Properties.VariableNames, ...
    'Cue')); % Cue or Placebo

sleepscorelabels = {    ...
    'Awake',    0;      ...
    'REM',      5;      ...
    'NREM1',    1;      ...
    'NREM2',    2;      ...
    'NREM3',    3;      ...
    'NREM4',    4;      ...
    'MT',       8       };



%% Start

all_stage        = out_sleepstages{:, idx_odor};
all_arousals     = out_arousals{:, idx_odor};


for i_sub = 1:size(all_stage,2)
   
    valid_scores               = all_stage(~isnan(all_stage(:,i_sub)),i_sub);
    non_awake                  = find(valid_scores ~= 0);
    sleep_onset(i_sub, 1)      = non_awake(1);
    total_scores(i_sub, 1)     = numel(valid_scores);
    total_awake(i_sub, 1)      = numel(valid_scores(valid_scores == 0));
    total_nrem1(i_sub, 1)      = numel(valid_scores(valid_scores == 1));
    total_nrem2(i_sub, 1)      = numel(valid_scores(valid_scores == 2));
    total_nrem3(i_sub, 1)      = numel(valid_scores(valid_scores == 3));
    total_nrem4(i_sub, 1)      = numel(valid_scores(valid_scores == 4));
    total_sws(i_sub, 1)        = total_nrem3(i_sub) + total_nrem4(i_sub);
    total_rem(i_sub, 1)        = numel(valid_scores(valid_scores == 5));
    total_mt(i_sub, 1)         = numel(valid_scores(valid_scores == 8));
    total_arousals(i_sub, 1)   = numel(find(all_arousals(:, i_sub) == 1));
    non_mt                     = find(valid_scores ~= 8);
    total_sleep(i_sub, 1)      = numel(intersect(non_awake, non_mt));
    
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
    plot(xvector * 30 / 60, -valid_scores, 'Color', 'k', 'LineWidth', 1.5)
    % Invert sleep scores so that deepest stages are lowest on plot
    ylim([-5.5, 0.5])
    yticks(-6:1:0)
    yticklabels({'', ...
        'REM', ...
        'NREM3 (S4)', ...
        'NREM3 (S3)', ...
        'NREM2', ...
        'NREM1', ...
        'Wake', ''})
    ylabel('Sleep stge')
    xlabel('Time')
    title(char(strcat('Subject:', {' '}, num2str(i_sub))))
    
end

stimulationnight.perc_nrem1      = total_nrem1   .* 100 ./ total_scores;
stimulationnight.min_nrem1       = total_nrem1   .* 30 ./ 60; % 30s scores
stimulationnight.perc_nrem2      = total_nrem2   .* 100 ./ total_scores;
stimulationnight.min_nrem2       = total_nrem2   .* 30 ./ 60; % 30s scores
stimulationnight.perc_nrem3      = total_nrem3   .* 100 ./ total_scores;
stimulationnight.min_nrem3       = total_nrem3   .* 30 ./ 60; % 30s scores
stimulationnight.perc_nrem4      = total_nrem4   .* 100 ./ total_scores;
stimulationnight.min_nrem4       = total_nrem4   .* 30 ./ 60; % 30s scores
stimulationnight.perc_sws        = total_sws     .* 100 ./ total_scores;
stimulationnight.min_sws         = total_sws     .* 30 ./ 60; % 30s scores
stimulationnight.perc_rem        = total_rem     .* 100 ./ total_scores;
stimulationnight.perc_waso       = total_waso    .* 100 ./ total_scores;
stimulationnight.min_waso        = total_waso    .* 30 ./ 60;
stimulationnight.sleep_onset     = sleep_onset   .* 30 ./ 60;
stimulationnight.perc_sleep      = total_sleep   .* 100 ./ total_scores;
stimulationnight.min_sleep       = total_sleep   .* 30 ./ 60;
stimulationnight.num_mt          = total_mt;
stimulationnight.num_arousals    = total_arousals;
stimulationnight.efficiency      = stimulationnight.min_sleep .*100 ./ ...
                                    (total_scores .* 30 ./ 60);



%% stats

type_data = 'perc_nrem4';

mean(stimulationnight.(type_data))
std(stimulationnight.(type_data))
