 function[tt]=tps_sam( num_c,size_c,Sa,t_id, t_id2, t_inf) 
            gs=num_c;
            Arand=ones(1,gs)*size_c;
            s_num=size_c*Sa;
            t2=0;
            jicaiyang=zeros(gs,s_num);
            flag=0;
            ppad=ones(1,gs);
            while (flag==0)
                gs_num=gs;
                Mguding=zeros(1,gs);
                for i=1:1:gs
                    Mguding(i)=Arand(i);
                end;
                sumshu=sum(Arand);
                NumM=Mguding;
                M=NumM;
                to=sumshu;
                lunshu=0;
                AD=ones(1,gs);
                miss=zeros(1,100);
                for i=1:1:100
                    miss(i)=i;
                end;
                for i=1:gs
                    AD(i)=i;%记录组的ID
                end;
                %---设置好了已知标签和未知标签，开始一次实验，多伦循环------------
                while(gs_num~=0) 
                    mk=zeros(1,gs);
                    for i=1:1:gs
                        mk(i)=M(i);
                    end;
                    if to>100
                        f=ceil(gs_num*1);
                    else
                        f=gs_num;
                    end;
                    AV2=zeros(1,f); %用来记录每次哈希映射使用的时隙
                    lunshu=lunshu+1;
                    EV1=zeros(1,f);
                    EV11=zeros(1,f);
                    AV1=zeros(1,f);
                    shanchu=zeros(1,gs);
                    k=1;
                    
                    %------映射M标签
                    result1=zeros(1,gs); %记录每个组ID的选择
                    for i=1:1:gs_num
                        aaaa=unidrnd(f);
                        result1(k)=aaaa; %将这些标签放到同一行中
                        k=k+1;
                    end;
                    
                    %----做了两次哈希映射
                    x=unique(result1);%不同元素个数
                    y=(result1);
                    [m1,n1]=hist(y,x); %m为n在Y中出现的次数
                    % ------两次哈希映射
                    for i=1:1:length(n1)
                        if n1(i)>0
                            EV11(n1(i))=m1(i);
                        end;
                        if m1(i)==1 && n1(i)>0
                            EV1(n1(i))=1;
                        end;%EV中只有一个标签映射的时候才为1
                    end;
                    zxc=0;
                    for i=1:1:f
                        flag=0;
                        if EV11(i)==0||EV11(i)>1
                            AV1(i)=0; %空时隙为0
                            
                        else if EV11(i)==1 &&AV2(i)==0
                                a=find(result1==i);
                                record_num=zeros(1,16); %记录每个标签映射的index的数量
                                record_index=zeros(1,16); %记录每个标签映射的index
                                for j=1:1:Arand(a)
                                    mm=rand(1,1);
                                    sump=0; %累计概率
                                    for js=1:1:16
                                        if mm>sump&&mm<=sump+(1/(2^js))
                                            record_num(js)=record_num(js)+1; %记录对应的区间
                                            record_index(js)=j; %记录对应的区间
                                        end;
                                        sump=sump+(1/(2^js));
                                    end;
                                end;
                                uindex=find(record_num==1);
                                if isempty(uindex)==0
                                    if isempty(find(jicaiyang(AD(a),:)==record_index(uindex(1)),1))&&ppad(AD(a))<=s_num %之前没采样过
                                        jicaiyang(AD(a),ppad(AD(a)))=record_index(uindex(1)); %记录采样的标签组别和系数
                                        ppad(AD(a))=ppad(AD(a))+1;
                                    end;
                                    AV1(i)=1;
                                    shanchu(zxc+1)=a;
                                    zxc=zxc+1;
                                    gs_num=gs_num-1;
                                       
                                else
                                    AV1(i)=0;
                                end;
                            end;
                        end;
                    end;
                    
                    for i=1:1:f
                        if AV1(i)~=0
                            AV2(i)=1;
                        end;
                    end;
                    
                    AD(shanchu(1:zxc))=[]; %这组有一个单时隙，则该组去除
                    EVt=(f/96)*t_id;
                    t2=t2+EVt;% 当jj=0时，为CCG算法，并计算时间
                    to=length(AD)*(sumshu/gs);
                end;
                
                if sum(ppad)==((s_num+1)*gs)
                    flag=1; %采集满了
                end;  
                %  t2=t2+(25*w+200)*gs+(4*37.45+200)*gs;%加上polling和采集的数据
                t2=t2+t_inf*gs+(gs*(4)/96)*t_id;%加上polling和采集的数据
            end;
            tt=t2./1000000;
