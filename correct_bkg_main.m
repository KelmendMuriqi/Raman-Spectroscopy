% Load the data
file_path = '/MATLAB Drive/operando_blue_25%_20x5_1.txt';
[n, y] = load_data(file_path);

% Preallocate matrix to store the background corrections (z) and corrected data
z_all = zeros(size(y));  % Same size as y
y_cor = zeros(size(y));  % Same size as y

% Loop over each measurement in y (each row is a separate measurement)
for i = 1:size(y, 1)
    % Apply the backcor function to each row individually
    [z, a, it, ord, s, fct] = backcor(n, y(i, :), 10, 0.001, 'atq');
    
    % Ensure z is a row vector (reshape or extract if needed)
    z = z(:)';  % Convert z to a row vector if it's not already
    
    % Store the estimated background for this measurement
    z_all(i, :) = z;
    
    % Subtract the background from the original signal for this row
    y_cor(i, :) = y(i, :) - z;
end

% Plot all corrected signals
figure;
hold on;
for i = 1:size(y_cor, 1)
    plot(n, y_cor(i, :));
end
title('Corrected Signals');
xlabel('Wavenumber');
ylabel('Corrected Intensity');
legend('show');  % Display legends for the measurements
hold off;

output_file = ['/MATLAB Drive/cor_operando_blue_25%_20x5_1.txt'];

% Create the matrix with wavenumbers as the first row and corrected intensities in subsequent rows
corrected_data = [n; y_cor];  % First row is wavenmbers, following rows are measurements

% Transpose the matrix so that each row corresponds to one measurement (including wavenumbers as the first row)
%corrected_data = corrected_data';

% Save to a file (rows: wavenumbers and corrected intensities)
dlmwrite(output_file, corrected_data, 'delimiter', '\t', 'precision', 6);

disp('Corrected data saved to corrected_y_values.txt');
