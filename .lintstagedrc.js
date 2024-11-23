module.exports = {
  "**.tf": async () => {
    return [`terraform fmt --recursive`];
  },
};
