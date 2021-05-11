function[tt]=top_sam(num_c,size_c,Sa,t_id, t_id2, t_inf)
            Mguding=num_c*size_c*Sa;
            Uguding=num_c*size_c*(1-Sa);
            T_uns=Uguding;
            T_s=Mguding;
            NumM=T_s;
            NumU=T_uns;
            lunshu=0;
            A=zeros(1,T_s+T_uns);
            wen=0;
            t=0;
            tll=0;
            for i=1:T_s+T_uns
                A(i)=i;
            end;

            while(wen==0)
                idresult1=zeros(1,T_s);
                Uidresult1=zeros(1,T_uns);
                if T_s+T_uns>2
                    f=round(sqrt(96*(T_uns+T_s-T_s)*T_s));
                else
                    f=T_s+T_uns;
                end;
                wen=wen+1;
                lunshu=lunshu+1;
                EV1=zeros(1,f);
                EV2=zeros(1,f);               
                EV11=zeros(1,f);
                EV22=zeros(1,f);
                AV1=zeros(1,f);
                AV=zeros(1,f);
                for i=1:1:T_s
                    aaaa=unidrnd(f);
                    idresult1(i)=aaaa;
                end;
                x=unique(idresult1);
                y=(idresult1);
                [m1,n1]=hist(y,x); 
                % ------
                for i=1:1:length(n1)
                    if n1(i)>0
                        EV11(n1(i))=m1(i);
                    end;
                    if m1(i)==1
                        EV1(n1(i))=1;
                    end;
                end;
              
                for i=1:1:T_uns
                    
                    Uidresult1(i)=unidrnd(f);
                    
                end; 
                result1=[idresult1,Uidresult1];
                xa=unique(result1);
                ya=result1;
                [ma1,na1]=hist(ya,xa);              
                for i=1:1:length(na1)
                    if na1(i)>0
                        AV1(na1(i))=ma1(i);
                    end;
                end;
                dan=0;
                danM=0;
                danU=0;
                for i=1:1:f
                    flag=0;
                    dada=0;
                    dadaU=0;
                    if AV1(i)>0
                        a=find(result1==i);
                        if length(a)>1
                            for z=1:1:length(a)
                                e=A(a(z));
                                if e<=Mguding
                                    flag=1; 
                                    dada=dada+1; 
                                else
                                    dadaU=dadaU+1; 
                                end;
                            end;
                            if dada>1   
                                danM=danM+dada-1;
                                dan=dan+1;
                                danU=danU+dadaU;
                            else if dada==1
                                    dan=dan+1;
                                    danU=danU+dadaU;
                                end;
                            end; 
                            
                        else if length(a)==1
                                if a<=Mguding
                                    AV(i)=1;
                                    dan=dan+1;
                                end;
                            end;
                        end;
                    end;
                end;
                EVt=(f/96);
                t=t+EVt*t_id+t_inf*(dan+danM)+(danM+danU)*t_id;
                T_s=NumM;
                T_uns=NumU;
                tll=tll+EVt;
            end;
            tt=t./1000000;
