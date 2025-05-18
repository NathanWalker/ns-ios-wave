import { NativeScriptConfig } from '@nativescript/core';

export default {
  id: 'org.nativescript.nsioswave',
  appPath: 'src',
  appResourcesPath: 'App_Resources',
  android: {
    v8Flags: '--expose_gc',
    markingMode: 'none'
  },
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
} as NativeScriptConfig;