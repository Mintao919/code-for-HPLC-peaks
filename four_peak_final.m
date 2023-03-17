%===== Min Tao The University of Sheffield
%=====Copyright (c) Min Tao, 2023, All rights reserved.
clear variables;
clc;
%--------------------------------------------------------------------------     
%--------------------------------------------------------------------------
name = dir('C:\Users\CBE-User ZK01\Desktop\RNA-based manufacturing\Emma_data1\Four_peaks\test files for Min\*.txt');
N=29; % Number of files
p=0.01;
location = zeros(M);
Pvalue = zeros(M);
lenvalue = zeros(M);
Peak_out=zeros(N,2*M);
len_out=zeros(N,1*M);
fileID = fopen('C:\Users\CBE-User ZK01\Desktop\RNA-based manufacturing\Emma_data1\Four_peaks\test files for Min\output.txt','w');
fprintf(fileID,'%42s %16s %16s %16s %16s %16s %16s %16s %16s %16s %16s %16s %16s\n','filename','Peak1 location','Peak1 value','Peak1 width','Peak2 location','Peak2 value','Peak2 width','Peak3 location','Peak3 value','Peak3 width','Peak4 location','Peak4 value','Peak4 width');
for k=1:N
    fid=fopen(['C:\Users\CBE-User ZK01\Desktop\RNA-based manufacturing\Emma_data1\Four_peaks\test files for Min\',name(k).name],'r');%% 
    ff = fgetl(fid);
    while(convertCharsToStrings(ff) ~=convertCharsToStrings('Time(min)	Step(sec)	Value(mAU)') && convertCharsToStrings(ff) ~=convertCharsToStrings('Time (min)	Step (s)	Value (mAU)'))
        ff=fgetl(fid);
    end
fgetl(fid);  
data1=fscanf(fid,'%16f %16f %16f',[3 inf]);  
fclose(fid);       
for j=1:4
  max_val=max(data1(3,:));
  Peak_idx=find(data1(3,:)==max_val);
  for i=Peak_idx:-1:1
    if (data1(3,i)<data1(3,i-1)-p) 
        break
    end
  end
  s_Peak_idx=i;
  for i=Peak_idx:1:size(data1(3,:),2)
    if data1(3,i) + p < data1(3,i+1)
        break
    end
  end
  e_Peak_idx=i;
  if (data1(3,e_Peak_idx) > data1(3,s_Peak_idx))
    for i=s_Peak_idx:1:Peak_idx
       if data1(3,i)-data1(3,e_Peak_idx) < -p/10
           s_Peak_idx=i;
        break
       end
    end
  end
  %=======================================================================>
  if (data1(3,e_Peak_idx) <= data1(3,s_Peak_idx))
    for i = e_Peak_idx:-1:Peak_idx
       if data1(3,i)-data1(3,s_Peak_idx) > p/10
             e_Peak_idx=i;
        break
       end
    end
  end
location(j)=data1(1,Peak_idx);
Pvalue(j)=data1(3,Peak_idx);
lenvalue(j)=abs(data1(1,e_Peak_idx)-data1(1,s_Peak_idx));
data1(3,s_Peak_idx:e_Peak_idx) = min(data1(3,s_Peak_idx),data1(3,e_Peak_idx));
end
[location1,I]=sort(location);
Pvalue1=Pvalue(I);
lenvalue1=lenvalue(I);
for j=1:4
Peak_out(k,(j-1)*2+1) = location1(j);
Peak_out(k,(j-1)*2+2) = Pvalue1(j);
len_out(k,j)=lenvalue1(j);
end
fprintf(fileID,'%42s  %16f %16f %16f %16f  %16f %16f %16f %16f  %16f %16f %16f %16f\n',name(k).name,Peak_out(k,1),Peak_out(k,2),len_out(k,1),Peak_out(k,3),Peak_out(k,4),len_out(k,2),Peak_out(k,5),Peak_out(k,6),len_out(k,3),Peak_out(k,7),Peak_out(k,8),len_out(k,4));
end
fclose(fileID);





