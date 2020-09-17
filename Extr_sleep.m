% |===USER INPUT===|
pathSleepScore      = 'D:\Gits\EEG_pre_processing\data_specific\GermanData\Hypnograms\';
% String of file path to the mother stem folder containing the files of
% sleep scoring of the subjects. LEAVE EMPTY ("''") IF DOES NOT APPLY

dataTypeScore       = '%f %f';  % Type of data content of file
str_delimiter       = ' ';
% We define structure of sleep scoring file and then import values

EEG.sleepscorelabels = { ...
    'Awake', 0;     ...
    'REM', 5;       ...
    'NREM1', 1;     ...
    'NREM2', 2;     ...
    'NREM3', 3;     ...
    'NREM4', 4;     ...
    'MT', 8         };
% |=END USER INPUT=|


% -------------------------------------------------------------------------
% Here we set up the list of sleep scoring files that will be processed in
% the script

ls_score        = dir(pathSleepScore);

% "dir" is also listing the command to browse current folder (".") and step
% out of folder (".."), so we reject these here
rej_dot         = find(strcmp({ls_score.name}, '.'));
rej_doubledot   = find(strcmp({ls_score.name}, '..'));
rej             = [rej_dot rej_doubledot];

ls_score(rej)   = [];


% Avoid potential errors
if strcmp(pathSleepScore(end), filesep)
    pathSleepScore(end) = [];
end
                  
for i_sub = 1:numel(ls_score)
    
    %% 2. Extract SWS (2, 3 and 4)
    %  ===========================
    % ---------------------------------------------------------------------
    % Here, we look for the sleep scoring file corresponding to the subject
    % and session of recording
    
    str_subjnum = char(extractBetween(ls_score(i_sub).name, 's', '_n'));
    num_sub     = str2double(str_subjnum);
    str_session = str2double(char((extractBetween(ls_score(i_sub).name, ...
        '_n', '.txt'))));
    
    if num_sub == 35
        continue
    end
    
    if (num_sub < 39 && str_session == 1) || ...
            (num_sub >= 39 && str_session == 2)
        str_session = 'Cue';
    elseif (num_sub < 39 && str_session == 2) || ...
            (num_sub >= 39 && str_session == 1)
        str_session = 'Placebo';
    else
        error('some error')
    end
    
    
    % We need to create a file identifier in order to scan it
    fid_score           = fopen(...
        [pathSleepScore filesep ls_score(i_sub).name]);
    
    [v_sleepStages]     = textscan(fid_score, dataTypeScore, ...
        'Delimiter', str_delimiter, 'CollectOutput', 1, 'Headerlines', 0);
    % Sleep stage values now stored in columns of cell array
    
    
    v_sleepStages       = cell2mat(v_sleepStages);
    v_sleeparousals     = v_sleepStages(:,2);
    v_sleepStages       = v_sleepStages(:,1);
    
    if i_sub == 1
        out_arousals = array2table(v_sleeparousals, 'VariableNames', ...
            {strcat(str_subjnum, '_', str_session)});
        out_sleepstages = array2table(v_sleepStages, 'VariableNames', ...
            {strcat(str_subjnum, '_', str_session)});
        
    else
        
        tmp_arousals        = array2table(v_sleeparousals, ...
            'VariableNames', {strcat(str_subjnum, '_', str_session)});
        tmp_sleepstages     = array2table(v_sleepStages, ...
            'VariableNames', {strcat(str_subjnum, '_', str_session)});
        
        diff_h              = height(tmp_arousals) - height(out_arousals);
        if diff_h < 0
            tmp_arousals    = [tmp_arousals; ...
                array2table(nan(abs(diff_h), 1), ...
                'VariableNames', {strcat(str_subjnum, '_', str_session)})];
            tmp_sleepstages = [tmp_sleepstages; ...
                array2table(nan(abs(diff_h), 1), ...
                'VariableNames', {strcat(str_subjnum, '_', str_session)})];
        elseif diff_h > 0
            out_arousals    = [out_arousals; ...
                array2table(nan(abs(diff_h), width(out_arousals)), ...
                'VariableNames', out_arousals.Properties.VariableNames)];
            out_sleepstages = [out_sleepstages; ...
                array2table(nan(abs(diff_h), width(out_sleepstages)), ...
                'VariableNames', out_sleepstages.Properties.VariableNames)];
        end
        
        out_arousals = [out_arousals, tmp_arousals];
        out_sleepstages = [out_sleepstages, tmp_sleepstages];
        
    end
    
end

