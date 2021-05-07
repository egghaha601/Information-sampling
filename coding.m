
clear all;
clc;
 
in='01000000';          
pr=[0.875 0.125];        %各字符出现的概率  
temp=[0.0 0.875 1.0];  
orignal=temp;  
 
n=length(in);  
%编码  
for i=1:n  
    width=temp(3)-temp(1);  
    w=temp(1);  
    switch in(i)  
        case '0'  
            m=1;  
        case '1'  
            m=2;  
    end  
    temp(1)=w+orignal(m)*width;  
    temp(3)=w+orignal(m+1)*width;  
    left=temp(1);  
    right=temp(3);  
    fprintf('left=%.6f',left);  
    fprintf('    ');  
    fprintf('right=%.6f\n',right);  
end  
encode=0.78125;
innum=encode;
N=6;
if (innum>1)|(N == 0)%判断输入的有效性
   disp('error!');
   return;
end
count=0;
tempnum=innum;
record=zeros(1,N);
while(N)
   count=count+1;%长度小于N
   if(count>N)
       N=0;
%        return;
    end
   tempnum=tempnum*2;%小数转换为二进制,乘2取整
    if tempnum>1
       record(count)=1;
       tempnum=tempnum-1;
   elseif(tempnum==1)
       record(count)=1;
       N=0;%stop loop
    else
      record(count)=0;    
    end
end
y=record;