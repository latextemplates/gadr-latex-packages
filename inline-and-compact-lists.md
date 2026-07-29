# How to typeset compact and inline lists

## Context and Problem Statement

The standard `itemize`/`enumerate` environments add vertical space and always
break onto their own lines. Sometimes a tight list, or a run-in list inside a
paragraph ((a) one, (b) two), reads better. How to get compact and inline lists?

## Considered Options

* standard environments (no extra package)
* [paralist](https://ctan.org/pkg/paralist)
* [enumitem](https://ctan.org/pkg/enumitem)

## Pros and Cons of the Options

### standard environments

- Good, because there is nothing to load.
- Bad, because there is no inline list and no easy compact variant.

### paralist

- Good, because it provides ready-made `compactitem`/`compactenum` (tight) and `inparaenum`/`inparaitem` (run-in) environments.
- Good, because it is small and simple.
- Bad, because it is older and less flexible for label and spacing tweaks, and must not be combined with enumitem.

### enumitem

- Good, because it is the modern, actively maintained package for full control of labels, spacing (`nosep`) and resuming lists.
- Good, because inline lists are available via the `inline` option (`enumerate*`).
- Bad, because for the simple "just give me a compact list" case it is more configuration than paralist.
