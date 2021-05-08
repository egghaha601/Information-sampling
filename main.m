edfsaa=zeros(1,10);
poll_t=zeros(1,10);
poll_bit=zeros(1,10);
acs_t=zeros(1,10);
acs_bit=zeros(1,10);
acs_bit2=zeros(1,10);
top=zeros(1,10);
tps=zeros(1,10);
iveki=zeros(1,10);
for num_c=100:100:1000 %number of categories 
    size_c=10; %category size
    Sa=0.1; %sampling rate
    w=10; % information length
    i=(num_c)/100;  
    t_id=(96*37.45+200); %the reader broadcast ID
    t_id2=(96*25+200); %tags reply ID
    t_inf=(w*25+200); % tags reply information
    for time=1:1:200
        edfsaa(i)=edfsaa(i)+edfsa_sam(num_c,size_c,Sa,t_id, t_id2, t_inf);
        [t,bit]=poll_sam(num_c,size_c,Sa,t_id, t_id2, t_inf);
        poll_t(i)=poll_t(i)+t;
        poll_bit(i)=poll_bit(i)+bit;
        [t, bit_c, bit_uc]=acs_sam(num_c,size_c,Sa,t_id, t_id2, t_inf);
        acs_t(i)=acs_t(i)+t;
        acs_bit(i)=acs_bit(i)+bit_c;
        acs_bit2(i)=acs_bit2(i)+bit_uc;
        tps(i)= tps(i)+tps_sam(num_c,size_c,Sa,t_id, t_id2, t_inf);
        iveki(i)= iveki(i)+iveki_sam(num_c,size_c,Sa,t_id, t_id2, t_inf);
        top(i)= top(i)+top_sam(num_c,size_c,Sa,t_id, t_id2, t_inf);
    end;
    edfsaa(i)=edfsaa(i)/time;
    top(i)=top(i)/time;
    poll_t(i)= poll_t(i)/time;
    poll_bit(i)=poll_bit(i)/time;
    acs_t(i)=acs_t(i)/time;
    acs_bit(i)=acs_bit(i)/time;
    acs_bit2(i)=acs_bit2(i)/time;
    tps(i)=tps(i)/time;
    iveki(i)=iveki(i)/time;
end;

% figure;
% i=1:1:10;
%  H= plot(i,edfsaa((i)/1),'-+',i,tps((i)/1),'-o',i,top((i)/1),'-d',i, poll_t((i)/1),'-x',i,iveki((i)/1),'-h',i,acs_t((i)/1),'-x');
%  axis([1 10 0 100]);
%  legend (H([1 2 3 4 5 6]),'EDFSA','TPS','TOP','Polling','IVEKI','ACS');
%  grid on;
% xlabel('Number of categories');
% ylabel('Execution time (s)');
