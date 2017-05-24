%% BW - macierz obrazka pozyskana z imread
%% BW - Metoda oblicza �rodek ci�ko�ci obrazka.
function position = calculateCenterMass(BW)
state = regionprops(BW, 'Centroid');
box = cat(1, state.Centroid);
x = box(255);
y = box(255,2);
position = [x, y];
end