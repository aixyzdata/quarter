module.exports = {
  default: {
    requireModule: ['ts-node/register'],
    require: ['tests/steps/*.js'],
    format: ['progress-bar', 'html:cucumber-report.html'],
    formatOptions: { snippetInterface: 'async-await' },
    publishQuiet: true
  }
}; 