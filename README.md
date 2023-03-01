# SDField.jl
Biblioteca numérica escrita en Julia para crear funciones distancia con signo en una malla estructurada y rectangular.

Uso:

```julia

    nx = 100 #
    ny = 100
    nz = 100

    mesh = HexaMesh([nx, ny, nz],[0.0, 0.0, 0.0],[1.0, 1.0, 1.0]);

    meshBuilder(mesh)
    
    
    phi1 = DistanceFields.sphere(0.5,0.5,0.5,0.1)
    phi2 = DistanceFields.sphere(0.1,0.1,0.1,0.08)

    sdf1 = SDField(mesh, phi1);
    sdf2 = SDField(mesh, phi2);

    #DistanceFields.add(sdf1,sdf2)

    sdf1<<sdf2

    vtkWriter(mesh, (sdf1.field,"Cilinder"), (sdf2.field, "Plane"))
```

