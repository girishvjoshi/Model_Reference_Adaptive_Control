function [km] = km_eval(X,x,sigma)
 
[row_length,col_length] = size(X);

    for ii =1:col_length
        
        km(ii,1) = exp(-(1/(2*sigma^2))*norm(X(:,ii)-x)^2);
        
    end
    

end