%print out values are: filename, cell_threshold, mt_threshold,total_MT_Length, median_MT_Length,mean_MT_Length, std_MT_Length, MT_Density 
%%% The goal of this code is to quantify the microtubule density within a
%%% cell. To do this, a maximum intensity projection of an RGB image of the
%%% microtubule network (labelled with a fluorophore, in the case of
%%% 2024 DARPin paper, was Tub-GFP) are generated. These are then loaded
%%% and band-pass filtered for analysis. Of note, there is a lower
%%% threshold for the cell than for the microtubule so that the cell
%%% ideally gets a mask for the entire cell and the threshold for the
%%% microtubules ideally only gets a mask for the microtubules. The output
%%% of this file is an excel sheet with a few different quantifications.
%%% The main quantification of interest is the MT density which is the
%%% fraction of the cell area that is covered by the microtubule mask. Of
%%% note, ideally the theshold will be consistent (for the MT and cell) for
%%% both imaging sets. However, in some cases, the theshold may look bad
%%% for both and so you may need different 2024 paper). The base Cell 
%%% theshold has been 0.00001. The base MT threshold was 0.02. For the images in this folder,
%%% they are all no DARPin cells. Of note, the code will stop and wait for
%%% user input (and button) to make sure the current settings look like
%%% they are in general capturing the microtubule density. 

%%%Before starting, change the ExcelOutput name to what you want, make sure
%%%all images are labelled with a similar sequential name in the same
%%%folder as this script, and adjust what is read with sprintf for filename
%%%to match the name of the images in the folder. 
 

clear;
clc;
close all;
%choose the name of the output file. 
ExcelOutput="9-20-23-200nMColchicineTreatedTubLLCs.xlsx";
%headers for the output file. 
output=["filename","cell threshold","MT threshold","Total MT Length","Median MT Length","mean MT Length","std MT Length","MT Density"];

currentOutput=zeros(1,7);
%number of images you are analyzing. If for any reason you have to restart
%partway through analyzing, just change the initial value for tests to
%start at the next image you want to analyze so that you don't have to
%reanalyze your images. 
for tests=1:30
%fid_alpha = fopen ('MAX_9-3-23-TubGFPWith200nMColchicinend0001.txt','a');
%thesholding for the microtubule and the cell. If needed, can adjust these
%to try to improve the quantification but should remain consistent across
%all treatment types. 
 mt_threshold = 0.02  
 cell_threshold = 0.00001 

    tests
    %Open the file of interest. 
    filename=sprintf('stacks%04d',tests);
    % Read image from path provided
    green_original_image_initial = imread(filename,'tif');
   
    green_original_image = green_original_image_initial(:,:,2);
    figure;
    imshow(green_original_image, [], 'Initialmagnification', 'fit'); %to verify processed image
    
  
  % green_original_image=double(green_original_image); %allows for decimal intensity values
    % noise filter
    my_noise_filter=fspecial('gaussian',7,1);
    noise_filtered_image=imfilter(green_original_image, my_noise_filter, 'symmetric');
    
    % background filter
    my_background_filter=fspecial('gaussian',21,3);
    background_filtered_image_MT_Detect=imfilter(green_original_image, my_background_filter, 'symmetric');
    
    % cell background filter
    my_cell_background_filter=fspecial('gaussian',2800,400);
    cell_background_filtered_image=imfilter(green_original_image, my_cell_background_filter, 'symmetric');
%     
%    Filtered image obtained by subtracting background_noise from the noise filtered image
    processed_green_mask_MT_Detect=noise_filtered_image-background_filtered_image_MT_Detect;
    
    processed_green_mask_Cell_Detect=noise_filtered_image-cell_background_filtered_image;
     
    
    %Make binary to create mask
    
   
    my_BW_image_MT_Detect=imbinarize(processed_green_mask_MT_Detect, mt_threshold); %.05 No H2O2 , .007 with H2O2 %making a black and white mask with the normalized image and threshold mask
 figure;
    imshow(my_BW_image_MT_Detect, [], 'Initialmagnification', 'fit'); % to show the black and white image
    
    %Make binary to create mask
    my_BW_image_Cell_Detect=imbinarize(processed_green_mask_Cell_Detect, cell_threshold); %.008 no H2O2 %was.05 %making a black and white mask with the normalized image and threshold mask
 figure;
    imshow(my_BW_image_Cell_Detect, [], 'Initialmagnification', 'fit'); % to show the black and white image
    
    
    
  
%     %Invert mask to create background red mask
     my_inverted_mask=abs(my_BW_image_MT_Detect-1); %obtaining an inverted mask where the black and white from my_BW_image above are interchanged
 
%     
%     %to convert binary to integer values
    my_BW_image2=uint8(my_BW_image_MT_Detect); %cell mask
     my_inverted_mask2=uint8(my_inverted_mask); %inverted background mask
     
%     
%     figure; 
     
%     %green_no_aurora=double(green_no_aurora);
    green_masked_image=my_BW_image2.*green_original_image; %applying my_BW_mask2 on green original image
    
    green_background_image = my_inverted_mask2.*green_original_image; 
    
   % figure;
   
   %imshow(green_masked_image, [], 'Initialmagnification', 'fit'); %to verify application of mask
  
%    
%    pause;
   
    %figure;
   % imshow(green_background_image, [], 'Initialmagnification', 'fit'); %to verify application of mask


  
idx=green_masked_image>0;
out=sum(idx(:));  %Number of pixels with signal

isabovethreshold = green_masked_image > 0;
sumintent = sum(sum(green_masked_image(isabovethreshold))) ; %total signal over pixels with signal

average_signal = sumintent/out ; %average signal intensity


idx2=green_background_image>0;
out2=sum(idx2(:))  %Number of pixels with signal

isabovethreshold2 = green_background_image > 0;
sumintent2 = sum(sum(green_background_image(isabovethreshold2)));  %total signal over pixels with signal

average_background = sumintent2/out2 ; %average signal intensity


meanFluorVals = average_signal;


%% MT length detection code %%

STATS_peri = regionprops(my_BW_image_MT_Detect, 'perimeter')
STATS_area = regionprops(my_BW_image_MT_Detect, 'area')
%
%
%create a histogram of perimeter and area
%
peri_array = [(STATS_peri.Perimeter)];
mt_length_array = peri_array./2;
total_MT_Length = sum(mt_length_array)
median_MT_Length = median(mt_length_array)
mean_MT_Length = mean(mt_length_array)
std_MT_Length = std(mt_length_array)
area_array = [(STATS_area.Area)];
total_MT_area = sum(area_array)

%% cell stats

cell_STATS_peri = regionprops(my_BW_image_Cell_Detect, 'perimeter')
cell_STATS_area = regionprops(my_BW_image_Cell_Detect, 'area')
cell_peri_array = [(cell_STATS_peri.Perimeter)];
cell_length_array = cell_peri_array./2;
total_cell_Length = sum(cell_length_array)
cell_area_array = [(cell_STATS_area.Area)];
total_cell_area = sum(cell_area_array)

MT_Density = total_MT_area/total_cell_area
k = waitforbuttonpress

%fprintf (fid_alpha,'%s %d %d %d %d %d %d %d ',filename, cell_threshold, mt_threshold,total_MT_Length, median_MT_Length,mean_MT_Length, std_MT_Length, MT_Density );
%    fprintf (fid_alpha,'\r\n');

position=tests+1;
%print data into excel sheet. 
currentOutput(1,1)=cell_threshold;
currentOutput(1,2)=mt_threshold;
currentOutput(1,3)=total_MT_Length;
currentOutput(1,4)=median_MT_Length;
currentOutput(1,5)=mean_MT_Length;
currentOutput(1,6)=std_MT_Length;
currentOutput(1,7)=MT_Density;
value="B"+position;
TitleValue="A"+position;
writematrix(currentOutput,ExcelOutput,'Sheet',1,'Range',value);
writematrix(filename,ExcelOutput,'Sheet',1,'Range',TitleValue);
writematrix(output,ExcelOutput,'Sheet',1,'Range',"A1");
    %fclose(fid_alpha)







   % k = waitforbuttonpress
close all;
end


