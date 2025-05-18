## Example using NativeScript with Wave

[Wave](https://github.com/jtrivedi/Wave), a spring-based animation engine for iOS, iPadOS, and macOS, make by [Janum Trivedi](https://github.com/jtrivedi).

https://github.com/user-attachments/assets/efdaf0f8-dd0f-4121-8818-53212b33f961

The Swift Package is included in [nativescript.config.ts](nativescript.config.ts):

```ts
ios: {
    SPMPackages: [
        {
            name: 'Wave',
            libs: ['Wave'],
            repositoryURL: 'https://github.com/jtrivedi/Wave',
            version: '0.3.3'
        }
    ]
}
```

### Try it

Prerequisites:
- [NativeScript Environment Setup](https://docs.nativescript.org/environment-setup.html)
- node >=20 

```bash
ns debug ios
```

This blends custom UIViews found in [native-views](src/app/native-views/), registered in [app.component](src/app/app.component.ts) into the [layout here](src/app/pip-example.component.html).

The pan gesture is blended into [TypeScript here](src/app/pip-example.component.ts) to call the Swift [handlePan event here](App_Resources/iOS/src/PIPWaveAnimator.swift).
