---
geometry: margin=1in
---

# Response to reviewer comments

## Reviewer 1

> *One thing that struck me was that this is a complicated way of achieving the same results as simple techniques such as THAR and AAR. The authors note that this "ELA model is similar in simplicity to field-based geomorphic methods such as the toe-to-headwall ratio (THAR) or accumulation area ratio (AAR)". If so, the authors need to stress more convincingly why this modelling approach is superior to the simple methods. There is some justification in the text, regarding errors and uncertainties and so on and this is important but needs more prominence through the paper. One other note on the quote above is that THAR and AAR are not field-based methods. They are achievable remotely using topographic maps and satellite imagery, so you shouldn't call them field-based methods.*

To address these concerns, we've added an Introduction section that better details traditional methods and highlights the key advantages of our method to address certain limitations of traditional empirical techniques (Lines 12-31).
We've also added an additional paragraph summarizing/comparing our method to other recent ELA methods (Lines 66-81).
The main thrust of these arguments are (1) less reliance on empirical coefficients that must be tuned using existing measured data, making their application to new regions or time periods more suspect, and (2) robust uncertainties that give greater context to the relevance of results and the sensitivity of results to specific inputs.
Finally, we include ELA estimates from 4 various empirical methods in our validation comparisons to highlight the proposed model's abilities relative to traditional techniques (Figure 6, Table 4, Lines 222-234).
We also specfically revised "field-based methods" to "empirical geomorphic methods" (Line 38).

> *The methods of the balance equation, glacier bed modelling, ice thickness modelling and glacier width modelling are based on theoretical concepts similar to those presented in the modelling papers of Pellitero et al. 2015 and 2016. I think some discussion of the Pellitero et al models is needed as this is the most recent set of papers related to the same idea presented in your paper. I think there is plenty of room for a new modelling approach like the one proposed in your new paper, but it seems odd if no mention is made of similar modelling papers.*

We have added an additional two paragraphs to the Methods section (Lines 58-81) detailing similarities and differences to other automated ELA calculations (Benn and Hulton, 2010; Pellitero et. al., 2015; and Pellitero et. al., 2016).

> *I think it would also be worth noting the empirical work done on glacier ELAs. Braithwaite and Raper (2009) found that the median altitude (area-median altitude) of glaciers best described the ELAs observed on 94 modern glaciers (R2 = 0.99). How do your models compare with these empirical observations? For example, on the four modern Swiss glaciers where is the ELA positioned - is it at the area-median altitude. I would also make some recommendation as to why your approach is superior to simply using GIS to measure the mean area-median altitudes on glaciers past and present. I do like the theoretical rigour of your approach, so I am note suggesting it is unnecessary, I just want to be more convinced on why it is better to apply this more complicated approach. Or simply tell us whether it nicely complements simpler approaches such as that using a mean area-median altitude approach.*

We feel the revised Intoduction section better addresses this concern, where we take greater lengths to discuss some of the previous empirical work done on ELAs (including reference to Braithwaite and Raper, 2009), as well as highlighting some of the areas our contribution can offer improvements (12-31).
We have also included additional comparisons of the observed/modeled ELA estimates and traditional empirical techniques in our model comparison section (Figure 6, Table 4, and Lines 222-234).

> *You say that the four Swiss glaciers were selected due to differences in overall shape, length and elevation extent. I've had a look at these glaciers online and they look similar sorts of glaciers to me. Can you please clarify what the differences were in the shape, length and elevation extent.*

We have edited this section to better reflect that the primary rationale for glacier selection was the availability of requisite data, with the diversity in glacier characteristics an important but secondary consideration (Lines 166, 179-171).
We have also included an additional table (Table 3) that better demonstrates the differences and similarities between the glaciers.

> *Spelling error: "geoemetries" should read "geometries"*

We have corrected the typo (Line 250).

> *You write that "The model described here accurately estimates ELAs from a variety of glacier sizes, shapes, topographies and areal distributions". It doesn't really, since all the glaciers are similar types of valley glaciers. Perhaps it would be more precise to write "The model described here accurately estimates ELAs from Alpine valley glaciers that have a variety of sizes, shapes, topographies and areal distributions.*

We have corrected the sentence to reflect that all validation was relative to Alpine valley glaciers (Line 263), while also noting in the Model Validation section that the theoretical underpinnings of the model should make it applicable to similar glaciers in other regions (Lines 172-174).

## Reviewer 2

> *Two references must be included within the manuscript:*

>> *Benn, D.I., Hulton, N.R.J., 2010. An Excel TM spreadsheet program for reconstructing the surface profile of former mountain glaciers and ice caps. Computers & Geosciences 36, 605-610.*

>> *Pellitero, R., Rea, B.R., Spagnolo, M., Bakke, J., Ivy-Ochs, S., Frew, C.R., Hughes, P., Ribolini, A., Lukas, S., Renssen, H., 2016. Glare, a GIS tool to reconstruct the 3D surface of palaeoglaciers. Computers & Geosciences 94, 77-85.*

We have added an additional two paragraphs to the Methods section (Lines 58-81) detailing similarities and differences to other automated ELA calculations (Benn and Hulton, 2010; Pellitero et. al., 2015; and Pellitero et. al., 2016).

> *Authors should discuss the opportunity to integrate the shape factor F in their method.*

We have added an additional paragraph that discusses possible improvements to the model, including implementing an F factor and non-parametric interpolation of the bed topography (Lines 251-260).

> *As a test of the ELA model's efficacy, authors compare the ELA modelled and measured for four present-day glaciers in the Swiss Alps. Readers would appreciate that the comparison be extended to other methods for ELA calculation such as AAR and AABR in order to appreciate the gap between ELA estimation from the presented physical steady-state model and empirical methods such as AAR and AABR.*

The model comparisons now also include ELA estimates using AAR, THAR, AMA, and MEG in addition to the observed and modeled ELAs, highlighting some of the improvements and advantages offered by the new method (Figure 6, Table 4, Lines 222-234).
The main results are the model does at least as well of these methods, and in some cases considerably better, while keeping the targeted advantages of the model (uncertainty estimates, sensitivity analysis, and decreased reliance on statistical coefficients).

## Miscellaneous notes

During revision, some of the calculated values changed slightly from the original results due to the stochastic nature of the Monte Carlo sampling.
We have now set a specific random seed for the sampling to ensure consistent results moving forward.
None of the changes materially impact the findings.
The updated values are present in Figure 6, Table 4, and Lines 226-229.
