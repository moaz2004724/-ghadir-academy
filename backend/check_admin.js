import { PrismaClient } from '@prisma/client';
import dotenv from 'dotenv';

dotenv.config();

const prisma = new PrismaClient();

async function checkUsers() {
  try {
    const users = await prisma.user.findMany();
    console.log("Current Database Users:");
    users.forEach(u => {
      console.log(`ID: ${u.id} | Email: '${u.email}' | Password: '${u.password}' | Role: ${u.role}`);
    });
  } catch (err) {
    console.error(err);
  } finally {
    await prisma.$disconnect();
  }
}

checkUsers();
