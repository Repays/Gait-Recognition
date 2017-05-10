%% BW - macierz obrazka pozyskana z imread
function rectangle = calculateRectangle(BW)
state = regionprops(BW, 'BoundingBox');
box = cat(1, state.BoundingBox);
x = box(255);
y = box(255,2);
width = box(255,3);
height = box(255,4);
rectangle = [x, y, width, height];
end