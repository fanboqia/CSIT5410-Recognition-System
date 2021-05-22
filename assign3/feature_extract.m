function fea = feature_extract(I)
% Complete task 1 here
  [m,n] = size(I);
  fea = [];
  i = 2;
  while i <= m-1
    j = 2;
    while j <= n-1
      digits = zeros(1,8);
      gc = I(i,j);
      digits(1) = I(i,j+1) >= gc; 
      digits(2) = I(i-1,j+1) >= gc; 
      digits(3) = I(i-1,j) >= gc; 
      digits(4) = I(i-1,j-1) >= gc; 
      digits(5) = I(i,j-1) >= gc; 
      digits(6) = I(i+1,j-1) >= gc; 
      digits(7) = I(i+1,j) >= gc; 
      digits(8) = I(i+1,j+1) >= gc; 
      
      % calculate the decimal value
      min_val = binary_to_decimal(digits);
      % circular shift 
      for looper = 1:7
        r_vec = mycircshift(digits,looper);
        new_val = binary_to_decimal(r_vec);
        if new_val < min_val
          min_val = new_val;
        end
      end
      
      fea = [fea,min_val];
      if m == 128
        j = j + 2;
      else
        j = j + 1;
      end
    end
    if m == 128
      i = i + 2;
    else
      i = i + 1;
    end
  end
end

function sum = binary_to_decimal(digits)
  len = length(digits);
  sum = 0;
  for i=1:len
    sum = sum + digits(len-i+1)*(2^(i-1));
  end
end

function r_vec = mycircshift(digits,shift_num)
  len = length(digits);
  r_vec = zeros(1,8);
  r_vec(1,len-shift_num+1:len) = digits(1,1:shift_num);
  r_vec(1,1:len-shift_num) = digits(1,shift_num+1:len);
end
