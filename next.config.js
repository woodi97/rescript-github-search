const bsconfig = require("./bsconfig.json");

// next 12.2부터  next compose plugins 사용할 경우 
// wrong config 에러가 발생함(next-compose-plugins가 no longer maintained임)
const withImages = require("next-images");

const transpileModules = ["rescript"]
  .concat(bsconfig["bs-dependencies"])
const withTM = require("next-transpile-modules")(transpileModules);


const config = {
  pageExtensions: ["jsx", "js"],
  reactStrictMode: true,
  webpack5: true
}

module.exports = (_phase, { defaultConfig }) => {
  const plugins = [withTM, withImages]
  return plugins.reduce((acc, plugin) => plugin(acc), { ...defaultConfig, ...config })
}