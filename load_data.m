function [n, y] = load_data(file_path)
    % LOAD_DATA   Load the wavenumber (n) and intensity (y) data from the file
    %
    %   [n, y] = LOAD_DATA(file_path) reads the spectral data from the specified
    %   file and returns the wavenumber vector n and intensity matrix y.
    %
    %   file_path : the path to the data file.
    %   n : Wavenumber values (first row of the file)
    %   y : Intensity values (subsequent rows of the file, excluding the time element)

    % Open the file
    fid = fopen(file_path, 'r');
    if fid == -1
        error('Cannot open file: %s', file_path);
    end

    % Initialize empty arrays for wavenumbers and intensities
    n = [];
    y = [];

    % Read through the file line by line
    first_row = true;
    while ~feof(fid)
        line = fgetl(fid);
        
        % Skip comments and empty lines
        if startsWith(line, '#') || isempty(line)
            continue;
        end
        
        % Convert the current line into numerical values
        line_data = str2double(strsplit(strtrim(line)));
        
        if first_row
            % The first row contains wavenumbers (n)
            n = line_data;
            first_row = false;  % Set the flag to false after reading the first row
        else
            % For subsequent rows, ignore the first element (time) and store intensities
            y = [y; line_data(2:end)];  % Skip the first element (time) in each row
        end
    end

    % Close the file
    fclose(fid);
end
