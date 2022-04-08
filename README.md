# GeneralIdentifiers

Dynamically generate nested structs for use in accessibility identifiers/analytic keys

Given a source file

```
Home,playButton,Play
Home,pauseButton,Pause
```

It will generate a nested struct that you can reference like:

```
let data = GeneralIdentifiers.playButton.play()
```

## Support

- Current version supports list to nested struct generation
- JSON decoder todo

## Configuration

Update the `SourceGeneratorConfiguration.json` to specify output preferences:

```
{
  "outputCasing": "camelCase",
  "sourceName": "GeneralIdentifiers.csv"
}
```
