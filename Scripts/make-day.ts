import path from 'node:path';
import fs from 'node:fs/promises';

import { exitWithValibotIssue } from './utils/validation';
import { type DayYearArgs, getDayYearArgs } from './utils/args';
import { fileExists, isDirectory } from './utils/fs';
import downloadInput from './utils/download-input';
import { getSessionIdEnv, type SessionEnv } from './utils/env';

const TEMPLATES_PATH = 'Templates';
const DAY_TEMPLATE_PATH = path.join(TEMPLATES_PATH, 'Dayx.swift.template');
const TEST_TEMPLATE_PATH = path.join(TEMPLATES_PATH, 'DayxTests.swift.template');

let values: DayYearArgs;
let env: SessionEnv;
let dayTemplateContent: string;
let testTemplateContent: string;
try {
  [values, env, dayTemplateContent, testTemplateContent] = await Promise.all([
    getDayYearArgs(),
    getSessionIdEnv(),
    fs.readFile(DAY_TEMPLATE_PATH, { encoding: 'utf8' }),
    fs.readFile(TEST_TEMPLATE_PATH, { encoding: 'utf8' }),
  ]);
} catch (error) {
  exitWithValibotIssue(error);
}

const yearSolutionsPath = `Sources/AdventOfCode${values.year}`;
const yearSolutionsIsDirectory = await isDirectory(yearSolutionsPath);
if (!yearSolutionsIsDirectory) {
  throw new Error('Solutions folder does not exist');
}

const yearTestPath = `Tests/AdventOfCode${values.year}Tests`;
const yearTestPathIsDirectory = await isDirectory(yearSolutionsPath);
if (!yearTestPathIsDirectory) {
  throw new Error('Test folder does not exist');
}

const dayDestinationPath = path.join(yearSolutionsPath, `Day${values.day}.swift`);
const testDestinationPath = path.join(yearTestPath, `Day${values.day}Tests.swift`);
const [dayDestinationExists, testDestinationExists] = await Promise.all([
  fileExists(dayDestinationPath),
  fileExists(testDestinationPath),
]);
if (dayDestinationExists && testDestinationExists) {
  console.log('Day already exists');
  process.exit(0);
}

function getCreationDate(): string {
  const now = new Date();
  const year = String(now.getFullYear()).slice(0, 2);
  const month = String(now.getMonth() + 1).padStart(2, '0');
  const day = String(now.getDate()).padStart(2, '0');

  return `${month}/${day}/${year}`;
}

function replaceTags(content: string, replacements: object) {
  let result = String(content);
  for (const [key, value] of Object.entries(replacements)) {
    const regex = new RegExp(`{{\\s*${key}\\s*}}`, 'g');
    result = result.replace(regex, String(value));
  }
  return result;
}

const replacements = { day: values.day, creation_date: getCreationDate(), year: values.year };
const filesToCreate: { filepath: string; content: string }[] = [];
if (!dayDestinationExists) {
  const newDayContent = replaceTags(dayTemplateContent, replacements);
  filesToCreate.push({ filepath: dayDestinationPath, content: newDayContent });
}
if (!testDestinationExists) {
  const newDayContent = replaceTags(testTemplateContent, replacements);
  filesToCreate.push({ filepath: testDestinationPath, content: newDayContent });
}

await Promise.all(filesToCreate.map(fileToCreate => fs.writeFile(fileToCreate.filepath, fileToCreate.content)));
console.log('Successfully created day');

const created = await downloadInput({ year: values.year, day: values.day, sessionId: env.AOC_SESSION_ID });
if (!created) {
  console.log('Input file already exists');
} else {
  console.log('Successfully stored input file');
}
