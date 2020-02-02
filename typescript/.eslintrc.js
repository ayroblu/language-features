module.exports = {
  extends: [
    'plugin:react/recommended', // Uses the recommended rules from @eslint-plugin-react
  ],
  env: {
    browser: true,
    es6: true,
  },
  parser: '@typescript-eslint/parser', // Specifies the ESLint parser
  parserOptions: {
    ecmaVersion: 2018, // Allows for the parsing of modern ECMAScript features
    sourceType: 'module', // Allows for the use of imports
    ecmaFeatures: {
      experimentalObjectRestSpread: true,
      jsx: true,
    },
    // Don't bother with tsconfig because it's super slow, just vanilla JS is good enough, rely on the tsc
    // project: 'typescript/tsconfig.json',
  },
  plugins: ['@typescript-eslint'],
  rules: {
    // Place to specify ESLint rules. Can be used to overwrite rules specified from the extended configs
    // e.g. "@typescript-eslint/explicit-function-return-type": "off",
    eqeqeq: 2,
    'react/display-name': 0,
    'react/jsx-key': 2,
    'react/jsx-curly-brace-presence': 2,
  },
  // Sometimes javascript and typescript ones aren't compatible
  overrides: [
    {
      files: ['*.js', '*.jsx'],
      rules: {
        'no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
      },
    },
    {
      files: ['*.ts', '*.tsx'],
      rules: {
        '@typescript-eslint/consistent-type-definitions': ['warn', 'type'],
        '@typescript-eslint/no-unused-vars': [
          'error',
          { argsIgnorePattern: '^_' },
        ],
      },
    },
  ],
  settings: {
    react: {
      version: 'detect', // Tells eslint-plugin-react to automatically detect the version of React to use
    },
  },
};
