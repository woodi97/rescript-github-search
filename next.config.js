/** @type {import('next').NextConfig} */
const withPlugins = require("next-compose-plugins");
const bsconfig = require("./bsconfig.json");
const withImages = require("next-images");

const transpileModules = ["rescript"]
.concat(bsconfig["bs-dependencies"])

const withTM = require("next-transpile-modules")(transpileModules);

const config = {
  pageExtensions: ["jsx", "js"],
  env: {
    ENV: process.env.NODE_ENV,
  },
  webpack: (config, options) => {
    const { isServer } = options;

    if (!isServer) {
      // We shim fs for things like the blog slugs component
      // where we need fs access in the server-side part
      config.resolve.fallback = {
        fs: false,
        path: false,
        process: false,
      };
    }

    config.module.rules.push({
      test: /\.m?js$/,
      use: options.defaultLoaders.babel,
      exclude: /node_modules/,
      type: "javascript/auto",
      resolve: {
        fullySpecified: false,
      },
    });
    return config
  },
  webpack5: true,
  reactStrictMode: true
};

module.exports = withPlugins(
  [
    [withTM],
    [
      withImages,
    ]
  ],
  config
);
