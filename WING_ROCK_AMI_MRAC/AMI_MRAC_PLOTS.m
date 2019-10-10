figure(1)
plot(T_REC,XREF_REC,'LineWidth',2);
hold on;
plot(T_REC,X_REC,'k--','LineWidth',2);
hold on
plot(T_REC,XREF,'r','LineWidth',2);
grid on;
legend('REF Model','Actual','R(t)');
ylabel('X');
xlabel('Time (secs)');

figure(2)
plot(T_REC,XREFDOT_REC,'r','LineWidth',2);
hold on;
plot(T_REC,XDOT_REC,'k--','LineWidth',2);
grid on;
legend('REF Model','Actual');
ylabel('dX/dt');
xlabel('Time (secs)');

figure(3)
plot(T_REC,D_REC,T_REC,DHAT_REC,'LineWidth',2);
grid on;
legend('d(x)','d^\^(x)');
ylabel('d(X)');
xlabel('Time (secs)');

figure(4)
plot(T_REC,WSTAR_REC,'--',T_REC,W_REC,'LineWidth',2);
grid on;
legend('weights');
ylabel('W');
xlabel('Time (secs)');
% 
% figure(5)
% plot(X_REC,XDOT_REC,'LineWidth',2);
% hold on;
% scatter(DICT_POINTS(1,:),DICT_POINTS(2,:),'ro');
% grid on;
% 
% % for index1 =1:length(RBF_C(1,:))
% %     
% %          
% %         scatter(RBF_C(1,index1)*ones(1,length(RBF_C(1,:))),RBF_C(2,:),'g');
% %         
% % end
% % legend('State Trajectory','GP Basis Centers','RBF Basis Centers');
% % xlabel('X');
% % ylabel('X_{dot}');
% 
figure(5)
plot(T_REC,ERR_REC,'LineWidth',2);
grid on;
