# SDField.jl
Biblioteca numérica escrita en Julia para crear funciones distancia con signo en una malla estructurada y rectangular.

Uso:

El siguiente código es un ejemplo para crear una SDF de un tanque(recipiente) al unir dos funciones distancia (Cilíndro + plano).

```julia

    nx = 100 #
    ny = 100
    nz = 100

    mesh = HexaMesh([nx, ny, nz],[0.0, 0.0, 0.0],[1.0, 1.0, 1.0]);
    meshBuilder(mesh) #creando el dominio computacional
    
    
    phi1 = DistanceFields.cilinder_Z(0.5, 0.5, 0.2) #creando un cilíndro de radio 0.2 
    phi2 = DistanceFields.planeZ(0.1) #creando un plano

    sdf1 = SDField(mesh, phi1);
    sdf2 = SDField(mesh, phi2);

    sdf1<<sdf2

    vtkWriter(mesh, (sdf1.field,"Tanque"))
```

