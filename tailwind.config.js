/* eslint-disable @typescript-eslint/no-var-requires */
/** @type {import('tailwindcss').Config} */
// generate custom color using https://tailwindcolorgenerator.com/
const appConfig = require('./src/core/config/appConfig');
const colors = require('tailwindcss/colors');

module.exports = {
  mod: 'jit',
  content: ['./src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    screens: {
      sm: '640px',
      md: appConfig.mobileAppMaxWidth,
    },
    extend: {
      transform: ['hover', 'focus'],
      margin: {
        center: '0 auto',
      },
      spacing: {
        'gb-header': appConfig.headerHeight,
        'bt-nav': appConfig.bottomNavigationHeight,
        'side-padding': appConfig.sidePadding,
      },
      maxWidth: {
        'mobile-app': appConfig.mobileAppMaxWidth,
      },
      colors: {
        primary: colors.green,
        secondary: colors.blue,
        link: colors.blue,
        gray: colors.gray,
        'primary-bg': appConfig.backgroundColor,
      },
    },
  },
};
