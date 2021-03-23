max_arr = [];
rho = sqrt((M^2+N^2));
max_rho = floor(rho)-1;
max_index = zeros(4,2);
table_copy = table;

for count=1:20
  max_arr = [max_arr max(max(table_copy))];
  [i,j]=find(table_copy==max(max(table_copy)));
  max_index(count,1) = i(1) - max_rho - 1;
  max_index(count,2) = j(1) - max_theta - 1;
  table_copy(i,j) = 0;
endfor 

% extract four peaks 
extract_index = zeros(4,2);
extract_index(1,:) = max_index(1,:);
for lol=1:3
  ro1 = extract_index(lol,:)(1);
  k = 1;
  while k <= length(max_index)
    ro2 = max_index(k,:)(1);
    if abs(ro1) - abs(ro2) > -100 && abs(ro1) - abs(ro2) < 100
      max_index(k,:) = [];
      k = k - 1;
    endif
    k = k + 1;
  endwhile
  extract_index(lol+1,:) = max_index(1,:);
endfor