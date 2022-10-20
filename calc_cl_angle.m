function alfa = calc_cl_angle(alfa,startM,endM,size,dist_in,max_dist)

dist = dist_in;
for i = (size-1):-1:startM
    alfa(i,endM) = atand(dist/max_dist);
    dist = dist + dist_in;
end

dist = dist_in;
for i = 2:1:(endM-1)
    alfa(startM,i) = 90 - atand(dist/max_dist);
    dist = dist + dist_in;
end

end