function complex_scientific_calculator()
    % Create the main figure
    f = figure('Name', 'Advanced Scientific Calculator', ...
               'NumberTitle', 'off', ...
               'Position', [300, 150, 500, 600], ...
               'Color', [0.3, 0.9, 0.9]);

    % Create a text box for displaying input/output
    display = uicontrol('Style', 'edit', ...
                        'FontSize', 16, ...
                        'HorizontalAlignment', 'right', ...
                        'BackgroundColor', 'white', ...
                        'Position', [20, 530, 460, 50], ...
                        'String', '');

    % Button labels and layout configuration
    buttons = { ...
        'sin', 'cos', 'tan', 'nCr', 'nPr'; ...
        'asin', 'acos', 'atan', 'log', 'ln'; ...
        'y√x', '√x', 'x^2', '1/x', 'e'; ...
        '(', ')', '^', '!', 'pi'; ...
        '7', '8', '9', '/', 'C'; ...
        '4', '5', '6', '*', 'DEL'; ...
        '1', '2', '3', '+', 'exp'; ...
        '.', '0', '=', '-', 'ans' ...
    };

    % Button dimensions and spacing
    button_width = 80;
    button_height = 50;
    x_start = 20;
    y_start = 450;
    x_spacing = 10;
    y_spacing = 10;

    % Initialize the calculator state
    input_value = '';
    previous_result = '';
    setappdata(f, 'input_value', input_value);
    setappdata(f, 'previous_result', previous_result);

    % Dynamically create buttons
    for i = 1:size(buttons, 1)
        for j = 1:size(buttons, 2)
            button_label = buttons{i, j};
            x_pos = x_start + (j-1) * (button_width + x_spacing);
            y_pos = y_start - (i-1) * (button_height + y_spacing);

            uicontrol('Style', 'pushbutton', ...
                      'String', button_label, ...
                      'FontSize', 14, ...
                      'BackgroundColor', [0.8, 0.8, 0.9], ...
                      'Position', [x_pos, y_pos, button_width, button_height], ...
                      'Callback', @(src, event) button_callback(button_label, display, f));
        end
    end
end

function button_callback(label, display, f)
    % Retrieve the current input value and previous result
    input_value = getappdata(f, 'input_value');
    previous_result = getappdata(f, 'previous_result');

    switch label
        % Numbers and operators
        case {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '+', '-', '*', '/', '^', '(', ')'}
            input_value = [input_value label];

        % Equals button to evaluate the expression
        case '='
            try
                result = eval(input_value);
                input_value = num2str(result);
                setappdata(f, 'previous_result', input_value);
            catch
                input_value = 'Error';
            end

         % Clear buttons
        case 'DEL'
            if ~isempty(input_value)
                input_value = input_value(1:end-1);  % Remove last character
            end
        case 'C'
            input_value = '';

        % Percentage calculation
        case '%'
             try
                  if ~isempty(userInput.expression)
                      result = eval([userInput.expression, '/100']);
                      set(resultBox, 'String', num2str(result));
                      userInput.expression = num2str(result);
                      userInput.cursor = length(userInput.expression) + 1;
                    else
                        set(resultBox, 'String', '0');
                    end
                catch
                    set(resultBox, 'String', 'Error');
                end

        % Trigonometric functions
        case 'sin'
            input_value = [input_value 'sind('];
        case 'cos'
            input_value = [input_value 'cosd('];
        case 'tan'
            input_value = [input_value 'tand('];


        case 'asin'
            input_value = [input_value 'asind('];
        case 'acos'
            input_value = [input_value 'acosd('];
        case 'atan'
            input_value = [input_value 'atand('];

        % Square root
        case '√x'
            input_value = [input_value 'sqrt('];

        % Exponential functions
        case 'exp'
            input_value = [input_value 'exp('];
        case 'log'
            % Base-10 logarithm
            input_value = [input_value 'log10('];
        case 'ln'
            % Natural logarithm
            input_value = [input_value 'log('];

        % Factorial
        case '!'
            try
                num = eval(input_value);
                if num == floor(num) && num >= 0
                    input_value = num2str(factorial(num));
                else
                    input_value = 'Error';
                end
            catch
                input_value = 'Error';
            end

        % Constant
        case 'pi'
            input_value = [input_value 'pi'];
        case 'e'
            input_value = [input_value 'exp(1)'];

        % Previous answer
        case 'ans'
            input_value = [input_value previous_result];

        case 'nPr' % Permutation calculation
                prompt = {'Enter n:', 'Enter r:'};
                dlgtitle = 'Permutation (nPr)';
                dims = [1 35];
                answer = inputdlg(prompt, dlgtitle, dims);
                if ~isempty(answer)
                    n = str2double(answer{1});
                    r = str2double(answer{2});
                    if n >= r && n >= 0 && r >= 0
                        input_value = num2str(factorial(n) / factorial(n - r));
                    else
                        input_value = 'Error';
                    end
                end


         case 'nCr' % Combination calculation
                prompt = {'Enter n:', 'Enter r:'};
                dlgtitle = 'Combination (nCr)';
                dims = [1 35];
                answer = inputdlg(prompt, dlgtitle, dims);
                if ~isempty(answer)
                    n = str2double(answer{1});
                    r = str2double(answer{2});
                    if n >= r && n >= 0 && r >= 0
                       input_value = num2str(factorial(n) / (factorial(r) * factorial(n - r)));
                    else
                       input_value = 'Error';
                    end
                end

       case 'y√x' % y-th root of x
                prompt = {'Enter x (the number):', 'Enter y (the root):'};
                dlgtitle = 'y√x Operation';
                dims = [1 35];
                answer = inputdlg(prompt, dlgtitle, dims);
                if ~isempty(answer)
                    x = str2double(answer{1});
                    y = str2double(answer{2});
                    if y ~= 0 % Ensure y is not zero to avoid division by zero
                        input_value = num2str(x^(1/y));
                    else
                        input_value = 'Error';
                    end
                end



       case 'x^2'
            input_value = num2str((eval(input_value))^2);
       case '1/x'
            input_value = [input_value '1/('];
    end

    % Update the display
    set(display, 'String', input_value);
    setappdata(f, 'input_value', input_value);
end

