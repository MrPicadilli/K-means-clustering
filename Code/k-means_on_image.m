im_classique=imread('../Data/Image/sun_flower.jpg');
im_change = zeros(size(im_classique,1),size(im_classique,2),3);
im_classique_double = double(im_classique);

nb_region = 3
K = zeros(nb_region,3);
new_K =zeros(nb_region,3);
C =zeros(nb_region,3);


aleatoire_x = randperm(size(im_classique,1));
aleatoire_y = randperm(size(im_classique,2));

aleatoire_rgb = randperm(255);
iteration = 0;

K(1,:) =im_classique_double(aleatoire_x(1),aleatoire_y(1),:);
K(2,:) = im_classique_double(aleatoire_x(2),aleatoire_y(2),:);
K(3,:) = im_classique_double(aleatoire_x(3),aleatoire_y(3),:);
x = 1;
y = 1;
ququ = sum(C(:)) 

while(sum(C(:)) != 9)
distance = zeros(nb_region,4);
  new_K(:,:) = K(:,:);

    while(x != size(im_classique,1)) 
    y = 1;
      while(y != size(im_classique,2)) 
      mindist = 1000000;
      j = 0;
      dist=0;
      distmin=1000;
      while(j != nb_region) 
        j = j+1;
        rouge = (im_classique_double(x,y,1) - K(j,1));
        vert = im_classique_double(x,y,2) - K(j,2);
        bleu = im_classique_double(x,y,3) - K(j,3);

        dist = sqrt((rouge*rouge)+(vert*vert)+(bleu*bleu));
        if dist < distmin
          mindist = j;
          distmin = dist;
        endif
      endwhile;
      distance(mindist, 1) = distance(mindist, 1)+1;
      distance(mindist, 2) = distance(mindist, 2) + im_classique_double(x,y,1);
      distance(mindist, 3) = distance(mindist, 3) + im_classique_double(x,y,2);
      distance(mindist, 4) = distance(mindist, 4) + im_classique_double(x,y,3);
      im_change(x,y,: )= [aleatoire_rgb(mindist) aleatoire_rgb(mindist+1) aleatoire_rgb(mindist+2)];
      y++;
      endwhile
    x++;
  endwhile;
  itere_region = 0;
  while (itere_region != nb_region)
      itere_region++;

  K(itere_region,1)  = distance(itere_region, 2) /  distance(itere_region, 1) ;
  K(itere_region,2) = distance(itere_region, 3) /  distance(itere_region, 1) ;
  K(itere_region,3) = distance(itere_region, 4) /  distance(itere_region, 1) ;
endwhile;
  C =  uint8(new_K) == uint8(K);
%{
  figure(2);
  imshow(uint8(im_change),[])
  title('k-means sur une image RGB')
  w = waitforbuttonpress;
  %}
  x = 1;
  iteration ++
endwhile;

  figure(2);
  imshow(uint8(im_change),[])
  title('k-means sur une image RGB')
