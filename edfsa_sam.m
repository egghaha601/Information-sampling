function[tt]=edfsa_sam(num_c,size_c,Sa,t_id, t_id2, t_inf)
            Mguding=num_c*size_c*Sa;
            Nguding=num_c*size_c*(1-Sa);
            T_all=Mguding+Nguding;
            Num_all=T_all;
            t2=0;
            B=zeros(1,T_all);
            for i=1:T_all
                B(i)=i;    %ÿ����ǩ���Լ��ı��(����Ϊ96λ)������ǰM��Ϊ��֪��ǩ����N��Ϊδ֪��ǩ
            end;
            while(T_all~=0)
                count=0;
                if T_all>4
                    f=round((T_all)/1);
                else
                    f=T_all;
                end;
                EV=zeros(1,f);
                AV=zeros(1,f);
                tag_sel=zeros(1,T_all);
                delete_uns=zeros(1,T_all); 
                k=0;
                
                for i=1:1:T_all
                    aaaa=unidrnd(f);
                    tag_sel(i)=aaaa;%����1��f���ȷֲ������������Ӧ�ڸ���֪��ǩidӳ���λ��;
                end;
                x=unique(tag_sel);%��ͬԪ�ظ���
                y=tag_sel;
                [m1,n1]=hist(y,x); %mΪn��Y�г��ֵĴ���
                for i=1:1:length(n1)
                    if n1(i)>0
                        AV(n1(i))=m1(i);
                    end;
                    if m1(i)>0
                        EV(n1(i))=1;
                    end;%EVΪ��Ӧ��1��ʱ϶��EV1Ϊ��Ӧ�ı�ǩ����
                end;
                
                for i=1:1:f
                    if  AV(i)==1
                        count=count+1;  %��¼��������֪��ǩ��
                        a=find(tag_sel==i); %�ҵ�ӳ�䵽��ʱ϶�ı�ǩ�±�
                        if sum(a)>0
                            for l=1:1:length(a)
                                e=B(a(l));
                                Num_all=Num_all-1;%һ������֪��ǩ
                                delete_uns(k+1)=e;%��¼��ɾ������֪��ǩ����һ�־�ī
                                k=k+1;
                            end;
                        end;
                    end;
                end;
                
                delete=[delete_uns(1:k)];
                delete_re=zeros(1,length(delete));
                for i=1:1:length(delete)
                    delete_re(i)=find(B==delete(i));%�ҳ���ɾ�����߾�Ĭ�ı�ǩ��A�ж�Ӧ���±�
                end;
                B(delete_re(1:k))=[];
                t2=t2+f*t_id2+count*t_inf;
                T_all=Num_all;
            end
            tt=t2./1000000;
            