%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Handwritten text recognition using Hopfield network (Modern)
% Author: Tomash Mikulevich
%
% The Modern Hopfield Network or 'Dense Associative Memory' with discrete 
% variables has been implemented. The classic Hopfield network, even with 
% the use of a fairly efficient second Order Storkey Rule, unfortunately 
% had unnecessary pixels after recognition, albeit with a certain threshold 
% value in some cases, they could be removed.
%
% IMPORTANT: The Hopfield network converges to the 'remembered' state when 
% some part of this state is given. Thus, such a network can supplement or 
% fix the image (e.g. with noise), but can not (in most cases) 'associate' 
% a completely new image.
%
% 1) After running the script, there are options in the console to choose 
% from, including selecting images to remember and image to recognize, 
% showing results and clearing data. There are also additional options 
% (e.g. adding noise) that appear when you upload an image for recognition.
%
% 2) It is possible to set the value of the parameter k in code, which is 
% the power in the nonlinear energy function F(x) = x^k, on which the 
% maximum capacity depends and, in fact, the accuracy of recognition 
% (the bigger the better).
%
% 3) All images must have identical dimensions and width = height 
% (e.g. 28×28 photos). Also, the folder with photos should have only 
% photos, otherwise there will be errors.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialization
clear;
N = 0;                  % Size of pictures (width = height)
imgMem = zeros();       % Matrix of memorized images 
imgTest = zeros();      % Tested image
imgRec = zeros();       % Recognized image

% Main loop (console interface)
while true
    line = "-------------------------------------------------";
    disp(line)
    textOption1 = "Please, enter the option:\n" + ...
                   " 0 - Show information about this project\n" + ...
                   " 1 - Choose folder/image to remember\n" + ...
                   " 2 - Choose image to recognize\n" + ...
                   " 3 - Show all memorized and recognized\n" + ...
                   " 4 - Clear all\n" + ...
                   " 5 - Exit\n" + ...
                   " Your choise: ";
    option1 = input(textOption1);
    disp(line)

    switch option1
        case 0
            showInfo()
        case 1
            [N,imgMem] = whatData(N,imgMem);
            disp("Done!")
        case 2
            [imgTest,imgRec] = chooseRec(imgMem);
            cla(); showResults(imgMem, imgTest, imgRec);
            disp("Done!")
        case 3
            if ~isempty(imgMem)
                cla(); showResults(imgMem, imgTest, imgRec);
                disp("Done!")
            else
                disp("There is no data!")
            end
        case 4
            [N,imgMem, imgTest, imgRec] = clearData();    
            disp("Done!")
        otherwise
            break
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Showing info about this project
function showInfo()
    welcome = "Handwritten text recognition using Hopfield network \n" + ...
              "Author: Tomash Mikulevich\n" + ...
              "Info:\n" + ...
              "The Modern Hopfield Network or 'Dense Associative Memory' " + ...
              "with discrete variables has been implemented. The classic " + ...
              "Hopfield network, even with the use of a fairly efficient " + ...
              "second Order Storkey Rule, unfortunately had unnecessary " + ...
              "pixels after recognition, albeit with a certain threshold " + ...
              "value in some cases, they could be removed.\n" + ...
              "IMPORTANT: The Hopfield network converges to the 'remembered' " + ...
              "state when some part of this state is given. Thus, such a " + ...
              "network can supplement or fix the image (e.g. with noise), " + ...
              "but can not (in most cases) 'associate' a completely new image.\n" + ...
              "1) After running the script, there are options in the console " + ...
              "to choose from, including selecting images to remember and " + ...
              "image to recognize, showing results and clearing data. " + ...
              "There are also additional options (e.g. adding noise) that " + ...
              "appear when you upload an image for recognition.\n" + ...
              "2) It is possible to set the value of the parameter k in code," + ...
              " which is the power in the nonlinear energy function " + ...
              "F(x) = x^k, on which the maximum capacity depends and, " + ...
              "in fact, the accuracy of recognition (the bigger the better).\n" + ...
              "3) All images must have identical dimensions and " + ...
              "width = height (e.g. 28×28 photos). Also, the folder with " + ...
              "photos should have only photos, otherwise there will be errors.\n" + ...
              "-------------------------------------------------";
    fprintf(welcome);
end

% Choosing what data to remember
function [N, ImgMem] = whatData(N, ImgMem)
    line = "-------------------------------------------------";
    textOption2 = "Please, enter the next option:\n" + ...
                   " 1 - Choose folder\n" + ...
                   " 2 - Choose one image\n" + ...
                   " 3 - Step back\n" + ...
                   "Your option: ";
    option2 = input(textOption2);
    disp(line)
    
    switch option2
        case 1
            [N, ImgMem] = chooseFol(ImgMem);
        case 2
            [N, ImgMem] = chooseImg(ImgMem);
        otherwise
            return
    end
end

% Choosing folder of images to remember
function [N, ImgMem] = chooseFol(ImgMem)
    dirFolder = uigetdir();
    imgFolder = dir(dirFolder);
    imgFolder = imgFolder(~[imgFolder.isdir]);
    numOfImages = length(imgFolder);
    cd(dirFolder);

    for i = 1:numOfImages
        img_binM = imbinarize(im2gray(imread(imgFolder(i).name)));
        img_bipM = bin2bip(img_binM);
        N = size(img_bipM,1);
        img_bipV = reshape(img_bipM,1,N*N);

        if i == 1 && ~isempty(ImgMem)
            ImgMem = zeros(numOfImages,N*N);
        end

        ImgMem(i,:) = img_bipV;
    end
end

% Choosing image to remember
function [N, ImgMem] = chooseImg(ImgMem)
    [fileName,dirName] = uigetfile('*.*');     cd(dirName);
  
    img_binM = imbinarize(im2gray(imread(fileName)));
    img_bipM = bin2bip(img_binM);          
    N = size(img_bipM,1);
    img_bipV = reshape(img_bipM,1,N*N);    
    
    ImgMem(end+1,:) = img_bipV;
end

% From 0/1 to -1/1
function BipolarImage = bin2bip(Image)
    BipolarImage = (Image == 1)*2-1;
end

% Choosing image to recognize
function [ImgTest, ImgRec] = chooseRec(ImgMem)
    [fileName,dirName] = uigetfile('*.*');     cd(dirName);
    img_binM = imbinarize(im2gray(imread(fileName)));
    img_bipM = bin2bip(img_binM);   

    line = "-------------------------------------------------";
    textOption3 = "Please, enter the noise (0-10): ";
    noiseLev = input(textOption3);
    disp(line)

    N = size(img_bipM,1);
    img_noiseM = addNoise(img_bipM, noiseLev);
    img_noiseV = reshape(img_noiseM,1,N*N);
    ImgTest = img_noiseM;

    if isempty(ImgMem)
        disp("Error! There is no learned elements!!!")
        ImgTest = 0;
        ImgRec = 0;
    else
        img_finalV = runNet(img_bipM, img_noiseV, ImgMem);   
        img_finalM = reshape(img_finalV,N,N);  
        ImgRec = img_finalM;
    end
end

% Adding noise
function NoiseImage = addNoise(ImageVector, NoiseLevel)
    NoiseImage = bin2bip(imnoise(ImageVector,'salt & pepper',0.1*NoiseLevel));
end

% Running net (https://en.wikipedia.org/wiki/Modern_Hopfield_network)
function newState = runNet(Original, State, ImgMem)
    [M,NN] = size(ImgMem);
    prevState = State;
    stabilized = false;
    begin = reshape(State,sqrt(NN),sqrt(NN));

    figure('Name','States','NumberTitle','off','WindowState','maximized');
    subplot(1,3,1), imshow(Original)
    title('Original Image')
    subplot(1,3,2), imshow(begin)
    title('Tested Image (with noise)')
    subplot(1,3,3), actual = imshow(begin,'InitialMagnification','fit');
    title('Actual State')

    while(~stabilized)
        shuffleV = randperm(NN);    % Asynchronous changing
       
        for l = shuffleV
            sum = 0;

            temp = prevState(l);
            prevState(l) = 1;
            e1 = prevState;
            prevState(l) = -1;
            e2 = prevState;
            prevState(l) = temp;

            for i = 1:M
                sum = sum + F(ImgMem(i,:) * e1.') - F(ImgMem(i,:) * e2.');
            end
            
            if sum > 0
                State(l) = 1;
            elseif sum < 0
                State(l) = -1;
            end
            
            next = reshape(State,sqrt(NN),sqrt(NN));
            set(actual,'CData',next);
            pause(3e-3)
        end

        stabilized = isequal(prevState,State);
        prevState = State;
    end
    
    figure('Visible', 'off')
    newState = State;
end

% Showing results
function showResults(ImgMem,ImgTest,ImgRec)
    [M,N] = size(ImgMem);
    gridX = 6;
    gridY = ceil(M/gridX);

    figure('Name','Memorized','NumberTitle','off','WindowState','maximized');
    for i = 1:M
        img_bipV = ImgMem(i,:);
        img_bipM = reshape(img_bipV,sqrt(N),sqrt(N));
        subplot(gridY,gridX,i), imshow(img_bipM)
        title(['#',num2str(i)])
    end

    figure('Name','Tested & Recognized','NumberTitle','off','WindowState','maximized');
    subplot(1,2,1), imshow(ImgTest)
    title('Tested')
    subplot(1,2,2), imshow(ImgRec)
    title('Recognized')
end

% Clearing data
function [N, imgMem, imgTest, imgRec] = clearData()
    clear
    N = 0;
    imgMem = zeros();
    imgTest = zeros();
    imgRec = zeros();
end

% Energy function
function y = F(x)
    k = 10;             
    y = x^k;
end