function point = intersectPoint(rayVector, rayPoint, planeNormal, planePoint)

pdiff = rayPoint - planePoint;
prod1 = dot(pdiff, planeNormal);
prod2 = dot(rayVector, planeNormal);
prod3 = prod1 / prod2;

point = rayPoint - rayVector * prod3;
