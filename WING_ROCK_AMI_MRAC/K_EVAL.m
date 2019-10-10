function [K] = K_EVAL(X,sigma)

 [row_length,col_length] = size(X);
 
 for ii = 1:col_length
     
     for iii = 1:col_length
         
         K(iii,ii) = exp(-(1/(2*sigma^2))*norm(X(:,iii)-X(:,ii))^2);
         
     end
 end
end