import { PrismaClient } from '@prisma/client';
import dotenv from 'dotenv';
import bcrypt from 'bcryptjs';

dotenv.config();

const prisma = new PrismaClient();

async function main() {
  console.log("Starting password hashing migration...");
  try {
    const users = await prisma.user.findMany();
    console.log(`Found ${users.length} total users in database.`);
    
    let updatedCount = 0;
    
    for (const u of users) {
      // bcrypt hashes are 60 chars long and start with $2a$ or $2b$ or $2y$
      const isAlreadyHashed = u.password.startsWith('$2a$') || u.password.startsWith('$2b$') || u.password.length === 60;
      
      if (!isAlreadyHashed) {
        console.log(`Hashing password for user: ${u.email} (Role: ${u.role})`);
        const hashedPassword = bcrypt.hashSync(u.password, 10);
        
        await prisma.user.update({
          where: { id: u.id },
          data: { password: hashedPassword }
        });
        updatedCount++;
      } else {
        console.log(`User: ${u.email} already has a hashed password. Skipping.`);
      }
    }
    
    console.log(`Successfully migrated ${updatedCount} users to hashed passwords.`);
  } catch (error) {
    console.error("Migration failed:", error);
  } finally {
    await prisma.$disconnect();
  }
}

main();
