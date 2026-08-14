# Provisioning

This project provisions and standardises our GitHub repositories and labels.
It uses OpenTofu as the base and stores the Tofu state in a GCS bucket (for now
it only stores it locally for internal reasons).

# Requirements

- **OpenTofu** version >= 1.12

> [!NOTE]
> This project can only be applied and ran by 9elements employees that have
> admin privileges on the canopybmc group!
> For 9e employees, contact the Canopy team via chat. For external contributors,
> consider opening an issue and describe what you'd like to be changed.
