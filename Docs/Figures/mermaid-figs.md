# Mermaid diagrams

A space to keep archival code to generate mermaid diagrams for use in the paper.
Go to the [live editor](https://mermaid-js.github.io/mermaid-live-editor/) in order to generate .png of the charts.

## Graphical abstract

```mermaid
graph LR
    subgraph Inputs
        a1>Bed topography <br>measurements]
        a2>Glacier width <br>measurements]
        a3>Model assumptions]
    end
    subgraph Intermediate Components
        b1{{Modeled bed <br>topography}}
        b2{{Modeled ice <br>thickness}}
        b3{{Modeled width}}
    end
    subgraph Model
        c{ELA_calc.m}
    end
    subgraph Outputs
        d1([ELA estimate])
        d2([ELA error])
    end
    a1 ==>|+Error| b1
    a3 ==> b1
    b1 ==>|+Error| b2
    a3 ==> b2
    b2 ==> b3
    a2 ==>|+Error| b3
    a3 ==> b3
    b1 ==>|+Error| c
    b2 ==>|+Error| c
    b3 ==>|+Error| c
    c ==> d1
    c ==>|+Monte Carlo| d2

classDef default fill:#5cfcfc,stroke:#333,stroke-width:1px
```

```json
{
  "theme": "forest",
  "flowchart": {
    "htmlLabels": false,
    "useMaxWidth": false,
    "rankSpacing": 15,
    "nodeSpacing": 50
  }
}
```

## ArcGIS workflow

```mermaid
graph LR
    subgraph Inputs
        iA[Aerial <br>imagery]
        iB[DEM]
    end
    A["Glacier <br>centerline <br>(freehand)"]
    B[Glacier <br>outline]
    iA --> A
    iA --> B
    A --> tA
    subgraph Tempory .xls file
        tA[Export <br>transect <br>elevation]
        tB[Export <br>transect <br>ice surface]
    end
    iB --> tA
    D["Find ice surface <br>elevation"]
    tA --> D
    D --> tB
    C[Orthogonal <br> centerline <br>transect]
    tB --> C
    B --> E[Clip width to <br>outline/<br>topography]
    C --> E
    iB --> E
    subgraph Output
        oA[Export to .csv]
    end
    E --> oA

classDef default fill:orange,stroke-width:2.5px
classDef matlab fill:#5cb1fc, stroke-width:2.5px
class D matlab
```

```json
{
  "theme": "forest",
  "flowchart": {
    "htmlLabels": false,
    "useMaxWidth": false,
    "rankSpacing": 15,
    "nodeSpacing": 50
  }
}
```
